module "db"{
  source = "terraform-aws-modules/rds/aws"
  identifier = "${var.project_name}-db"
  
  allocated_storage = 20
  db_name = "employee_db"
  engine = "mysql"
  engine_version = "8.0"
  major_engine_version = "8.0"
  family = "mysql8.0"
  instance_class = "db.t3.micro"
  username = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["username"]
  manage_master_user_password = true
  password_wo = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
  multi_az = true
  skip_final_snapshot = true
  publicly_accessible = false

  create_db_subnet_group = true
  subnet_ids = module.vpc.private_subnets
  db_subnet_group_name = "${var.project_name}-db-subnet-group"
  db_subnet_group_tags = {
    Name = "${var.project_name}-db-subnet-group"
   }
}