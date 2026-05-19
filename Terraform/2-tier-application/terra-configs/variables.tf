variable "secrets" {
  default = {
    username = "admin"
    password = "admin1234"
  }

  type = map(string)
}

variable "instance_type" {
  default = "t3.micro"
}

variable "project_name" {
  default = "2-tier-application"
}