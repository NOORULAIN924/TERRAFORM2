terraform {
  backend "s3" {
    bucket         = "noor-terraform-123"
    key            = "terraform/state.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}