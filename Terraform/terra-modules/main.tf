module "vpc" {
  source = "./modules/vpc"
  app_name = var.app_name
  vpc_cidr = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
}

module "security_group" {
  source = "./modules/security-group"
  app_name = var.app_name
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
    source = "./modules/ec2"
    app_name = var.app_name
    ec2_instance_type = var.ec2_instance_type
    security_group_id = module.security_group.security_group_id
    subnet_id = module.vpc.subnet_id
}