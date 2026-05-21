output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value = module.alb.dns_name
}


output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value = module.db.db_instance_endpoint
}