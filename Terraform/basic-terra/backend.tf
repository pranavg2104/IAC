# point the backend to the s3 to fetch the latest state

terraform{
    backend "s3"{
        bucket = "tf-state-preserver"
        key = "terraform.tfstate"
        region = "ap-south-1"
        use_lockfile = true
        encrypt = true
    }
}