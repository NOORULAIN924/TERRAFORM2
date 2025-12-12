############################################
# Disable Account-Level Block Public Access
############################################
resource "aws_s3_account_public_access_block" "account_bpa" {
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

############################################
# S3 Bucket
############################################
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

############################################
# Disable Bucket-Level Block Public Access
############################################
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

############################################
# S3 Static Website Hosting Configuration
############################################
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

############################################
# Bucket Policy to Allow Public Access
############################################
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website.id
  depends_on = [
    aws_s3_account_public_access_block.account_bpa,
    aws_s3_bucket_public_access_block.public
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

############################################
# DynamoDB for Terraform State Locking
############################################
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html")

  depends_on = [aws_s3_bucket_policy.public_policy]
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform Locks"
    ManagedBy = "Terraform"
  }
}
