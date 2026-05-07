
variable "ec2_instance_type" {
    type = string
    default = "t3.micro"
    description = "EC2 instance type"
}

variable "subnet_id" {
    description = "Subnet ID"
    type = string
}

variable "security_group_id" {
    description = "VPC ID"
    type = string
}

variable "app_name" {
    description = "Application name"
    type = string
}
