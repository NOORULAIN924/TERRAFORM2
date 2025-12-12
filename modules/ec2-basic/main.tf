resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-sg"
  }, var.tags)
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  associate_public_ip_address = true
  key_name               = var.key_name != "" ? var.key_name : null

  user_data_base64 = var.user_data

  tags = merge({
    Name = var.name
  }, var.tags)

  lifecycle {
    # module consumer can override if desired
  }

  provisioner "remote-exec" {
    when       = create
    on_failure = continue

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.ssh_private_key
      host        = self.public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx || sudo apt-get update && sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
