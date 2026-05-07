output "ec2_public_ip" {
    value = module.ec2.ec2_public_ip
    description = "EC2 Public IP"
  
}