locals {
  env = terraform.workspace
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pranav-${local.env}-website"

  control_object_ownership = true
  object_ownership = "BucketOwnerEnforced"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = "${module.s3_bucket.s3_bucket_arn}/*"
      }
    ]
  })

  tags = {
    Enviornment = local.env
  }
}

resource "aws_s3_object" "index" {
  bucket = module.s3_bucket.s3_bucket_id
  key = "index.html"
  source = "index/${local.env}/index.html"
  content_type = "text/html"
  
  depends_on = [ module.s3_bucket ]
}

resource "aws_s3_object" "error" {
  bucket = module.s3_bucket.s3_bucket_id
  key = "error.html"
  source = "index/error.html"
  content_type = "text/html"

  depends_on = [ module.s3_bucket ]
}