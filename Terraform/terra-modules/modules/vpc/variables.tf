variable "app_name" {
    type = string
    description = "Application Name"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR range for VPC"
}

variable "subnet_cidr" {
    type = string
    description = "CIDR range for Subnet"
}