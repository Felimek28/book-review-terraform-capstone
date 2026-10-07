# Web tier EC2 instance placed in the public subnet.
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.web_instance_type
  vpc_security_group_ids      = [var.web_sg_id]
  key_name                    = var.keyname
  subnet_id                   = var.web_subnet_1_id
  associate_public_ip_address = true
  user_data                   = var.web_user_data

  tags = {
    Name = "${var.project}-web-server"
  }
}

# App tier EC2 instance placed in the private subnet.
resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = var.app_instance_type
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.keyname
  subnet_id                   = var.app_subnet_1_id
  associate_public_ip_address = false
  user_data                   = var.app_user_data

  tags = {
    Name = "${var.project}-app-server-1"
  }
}

