module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.app_name
  cidr = "10.0.0.0/16"
  azs = ["ap-south-1a"]

  map_public_ip_on_launch = true
  public_subnets = ["10.0.1.0/24"]
  public_subnet_tags = {
    Name = "${var.app_name}-subnet"
  }

  create_igw = true
  igw_tags = {
    Name = "${var.app_name}-igw"
  }

  public_route_table_tags = {
    Name = "${var.app_name}-public-rt"
  }  

  tags = {
    Name = "${var.app_name}-vpc"
    tf_module = "true"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  vpc_id = module.vpc.vpc_id

  name = "${var.app_name}-sg"

  ingress_with_cidr_blocks = [
    {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
        description = "SSH access"
    },
    {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
        description = "HTTP access"
    }
  ]

  egress_with_cidr_blocks = [{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]

  tags = {
      Name = "${var.app_name}-sg"
    }
}


module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami = "ami-0dee22c13ea7a9a67"
  name = "my-portfolio-server"
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group.security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    cat > /var/www/html/index.html <<EOT
    ${file("${path.module}/index.html")}
    EOT
  EOF

  tags = {
    Name = "${var.app_name}-instance"
  }
}