# Provider 
 provider "aws" {
  region = var.region_controller
 }

# Security group
resource "aws_security_group" "tf_controller_sg" {  
  name = var.Name_controller
  description = var.sg_description_controller
  vpc_id      = data.aws_vpc.default.id

  tags = { 
    Name = var.tag_name_controller 
    }
}

# This is to declare my data source
data "aws_vpc" "default" {
  default = true
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "controller_allow_port22" {
  security_group_id = aws_security_group.tf_controller_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Egress rule
resource "aws_vpc_security_group_egress_rule" "controller_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf_controller_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "controller_deploy_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_controller
  key_name = var.key_name_controller
  vpc_security_group_ids = [aws_security_group.tf_controller_sg.id]

  tags = {
    Name = var.Name_controller
  }
}

  