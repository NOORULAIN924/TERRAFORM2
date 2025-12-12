output "website_url" {
  description = "Public S3 static website URL"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = var.bucket_name
}
