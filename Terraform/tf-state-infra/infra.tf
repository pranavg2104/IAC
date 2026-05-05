# S3 bucket with version enabled to store the tfstate file 

resource "aws_s3_bucket" "tf-state-preserve"{
    bucket = "tf-state-preserver"
    tags = {
        Name = "state-bucket"
    }
}

resource "aws_s3_bucket_versioning" "set_version"{
    bucket = aws_s3_bucket.tf-state-preserve.id

    versioning_configuration {
        status = "Enabled"
    }
}
