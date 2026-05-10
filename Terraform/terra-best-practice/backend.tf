# Store the tfstate file to s3 with encryption so that state is preserved

terraform{
    backend "s3"{
        bucket = "tf-state-preserver"
        key = "terraform.tfstate"
        region = "ap-south-1"
        use_lockfile = true
        encrypt = true
    }
}