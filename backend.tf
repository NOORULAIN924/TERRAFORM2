terraform {
  backend "s3" {
    bucket         = "noor-terraform-123-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "noor-terraform-123-tf-locks"
  }
}