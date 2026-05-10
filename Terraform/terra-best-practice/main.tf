provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH access"
    }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "s3_state_access_policy" {
  name        = "EC2-S3-State-Read-Policy"
  description = "Policy for EC2 to read the Terraform state file."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListAndLocation"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::tf-state-preserver"
      },
      {
        Sid    = "AllowReadStateFile"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::tf-state-preserver/terraform.tfstate"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2-S3-State-Reader-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Sid = ""
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "s3_state_attach" {
  role = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_state_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "EC2-S3-State-Reader-Profile"
  role = aws_iam_role.ec2_s3_role.name
}

resource "aws_instance" "web_server" {
  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t3.micro"
  key_name = "ssh-key"
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name = "best-practice"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNY4eRHKaOCwv/CvEAD7zHQa9J0ceckA4EhKuhasmp2 pranavg2104@gmail.com"
  tags = {
    Name = "best-practice"
  }
}
