output "ec2_public_ip" {
    value = aws_instance.server.public_ip
    description = "EC2 server public IP"
}