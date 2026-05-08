variable "instance_type" {
  description = "Server instance type"
  default = "t3.micro"
  type = string
}

variable "app_name"{
    type = string
    default = "pranav-portfolio"
    description = "Application name"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "VPC CIDR"
}

variable "subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "Subnet CIDR"
}