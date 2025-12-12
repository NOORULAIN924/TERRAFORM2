variable "aws_region" {
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  type        = string
  default     = "noor-terraform-123"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}

variable "key_name" {
  type        = string
  default     = ""
}
