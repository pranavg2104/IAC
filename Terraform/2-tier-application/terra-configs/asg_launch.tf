resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = module.iam_role.instance_profile_name
  }

  network_interfaces {
    security_groups = [module.app_security_group.security_group_id]
    associate_public_ip_address = false
  }

  user_data = base64encode(local.userdata)

}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  name = "${var.project_name}-asg"
  max_size = 2
  min_size = 1
  desired_capacity = 1

  vpc_zone_identifier = module.vpc.private_subnets

  launch_template_id = aws_launch_template.lt.id
  launch_template_version = "$Latest"

  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = module.alb.target_groups["alb_tg"].arn
    }
  }

  health_check_type = "ELB"
  health_check_grace_period = 120

  tags = {
    Name = "${var.project_name}-asg"
  }
}