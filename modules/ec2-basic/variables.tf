variable "name" {
  description = "Name prefix for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name (optional)"
  type        = string
  default     = ""
}

variable "use_provisioner" {
  description = "Whether to run remote-exec provisioner"
  type        = bool
  default     = false
}

variable "ssh_private_key" {
  description = "Private key for ssh connection (PEM string). Required if use_provisioner=true"
  type        = string
  default     = ""
}

variable "ssh_user" {
  description = "SSH user for connection (depends on AMI, e.g., ec2-user)"
  type        = string
  default     = "ec2-user"
}

variable "user_data" {
  description = "User data script for instance init"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}
