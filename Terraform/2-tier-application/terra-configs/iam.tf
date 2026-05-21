module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  
  name = "ec2-role"

  create_instance_profile = true

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  
}
