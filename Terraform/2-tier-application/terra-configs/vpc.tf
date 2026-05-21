module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.project_name
  }
}

module "lb_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name = "${var.project_name}-lb-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks  = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "app_security_group"{
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name = "${var.project_name}-app-sg"
  vpc_id = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
        source_security_group_id  = module.lb_security_group.security_group_id
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
  computed_egress_with_source_security_group_id = [
    {
        source_security_group_id  = module.lb_security_group.security_group_id
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  number_of_computed_egress_with_source_security_group_id = 1
}

module "rds_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name = "${var.project_name}-rds-sg"
  vpc_id = module.vpc.vpc_id

   computed_ingress_with_source_security_group_id = [
    {
        source_security_group_id  = module.lb_security_group.security_group_id
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
  computed_egress_with_source_security_group_id = [
    {
        source_security_group_id  = module.lb_security_group.security_group_id
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  number_of_computed_egress_with_source_security_group_id = 1
}