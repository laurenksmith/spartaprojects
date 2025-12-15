# Provider 
 provider "aws" {
  region = var.region_target-node-app
 }

# Security group
resource "aws_security_group" "target-node-app_sg" {  
  name        = var.sg_name_target-node-app
  description = var.sg_description_target-node-app
  vpc_id      = data.aws_vpc.default.id

  tags = { 
    Name = var.tag_name_target-node-app 
    }
}

# This is to declare my data source
data "aws_vpc" "default" {
  default = true
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "target-node-app_allow_port22" {
  security_group_id = aws_security_group.target-node-app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "target-node-app_allow_port3000" {
  security_group_id = aws_security_group.target-node-app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 3000
  to_port           = 3000
}

resource "aws_vpc_security_group_ingress_rule" "target-node-app_allow_port80" {
  security_group_id = aws_security_group.target-node-app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Egress rule
resource "aws_vpc_security_group_egress_rule" "target-node-app_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.target-node-app_sg.id
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

resource "aws_instance" "target-node-app_deploy_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_target-node-app
  key_name = var.key_name_target-node-app
  vpc_security_group_ids = [aws_security_group.target-node-app_sg.id]

  tags = {
    Name = var.Name_target-node-app
  }
}
