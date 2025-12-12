# Creates S3 bucket and DynamoDB table to be used for remote backend and locking.
# Run `terraform init` and `terraform apply -target=aws_s3_bucket.remote_state -target=aws_dynamodb_table.lock_table`
# Then update `backend.tf` with the backend configuration and run `terraform init -migrate-state`.

resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.bucket_name}-tfstate"

  tags = merge({
    Name = "tf-remote-state-${var.bucket_name}",
    ManagedBy = "terraform"
  }, var.common_tags)
}

resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "${var.bucket_name}-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge({
    Name = "tf-locks-${var.bucket_name}"
  }, var.common_tags)
}
