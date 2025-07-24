terraform {
  backend "s3" {
    bucket         = "srini-terraform-bucket"   # Replace with your bucket name
    key            = "srini/s3/terraform.tfstate" # Path inside the bucket
    region         = "us-east-1"                   # Replace with your AWS region
}
}
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}