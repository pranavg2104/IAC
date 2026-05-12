data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "tester_key" {
  key_name = "tester-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNY4eRHKaOCwv/CvEAD7zHQa9J0ceckA4EhKuhasmp2 pranavg2104@gmail.com"

  tags = {
    Name = "ansible-key"
  }
}

resource "aws_security_group" "ansible_sg" {
  name = "ansible-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
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
    description = "Allow Internet Access"
  }

  tags = {
    Name = "ansible-sg"
  }
}

resource "aws_instance" "server" {
  for_each = {
    for inst in local.instances : inst.name => inst.env
  }

  ami = "ami-0dee22c13ea7a9a67"
  instance_type = "t3.micro"
  key_name = aws_key_pair.tester_key.key_name

  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags ={
    Name = "${each.key}-ansible-ec2"
    Enviornment = each.value
  }
}
