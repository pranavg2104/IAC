output "instance_public_ips" {
  value = {
    for env in distinct(values(aws_instance.server)[*].tags.Enviornment) :
    env => [for k, inst in aws_instance.server : inst.public_ip if inst.tags.Enviornment == env]
  }
}