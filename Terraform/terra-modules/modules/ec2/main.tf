resource "aws_instance" "server" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = var.ec2_instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [ var.security_group_id ]

    user_data = <<-EOF
              #!/bin/bash
              apt get update -y
              apt install -y apache2
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