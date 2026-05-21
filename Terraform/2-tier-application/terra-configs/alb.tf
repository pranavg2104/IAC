module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal = false

  vpc_id = module.vpc.vpc_id

  security_groups = [module.lb_security_group.security_group_id]
  subnets = module.vpc.public_subnets

  target_groups = {
    alb_tg = {
        create_attachment = false
        name_prefix = "tg"
        port = 8000
        protocol = "HTTP"
        health_check = {
            path = "/health"
            protocol = "HTTP"
            matcher = "200"
            health_threshold = 2
            unhealthy_threshold = 3
            interval = 30
            timeout = 5
        }
    }
  }
  listeners = {
    alb_listner = {
        port = "80"
        protocol = "HTTP"
        forward = {
            target_group_key = "alb_tg"
        }
    }
  }
}