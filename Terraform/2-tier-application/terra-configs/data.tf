data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  db_creds = jsondecode(aws_secretsmanager_secret_version.admin.secret_string)
  userdata = templatefile("${path.module}/userdata.tpl", {
    DB_NAME = "employee_db"
    DB_USER = local.db_creds.username
    DB_PASSWORD = local.db_creds.password
    DB_PORT = "3306"
    DB_HOST = module.db.db_instance_endpoint
  })
}