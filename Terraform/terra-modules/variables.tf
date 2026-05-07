variable "region" {
    type = string
    default = "ap-south-1"
    description = "AWS region"
}

variable "app_name"{
    type = string
    default = "pranav-portfolio"
    description = "Application name"
}

variable "ec2_instance_type"{
    type = string
    default = "t3.micro"
    description = "Application name"
}