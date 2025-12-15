# Provider 
 provider "aws" {
  region = var.region_target-node-db
 }

# Security group
resource "aws_security_group" "target-node-db-sg" {  
  name        = var.sg_name_target-node-db-sg
  description = var.sg_description_target-node-db-sg
  vpc_id      = data.aws_vpc.default.id

  tags = { 
    Name = var.tag_name_target-node-db-sg 
    }
}

# This is to declare my data source
data "aws_vpc" "default" {
  default = true
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_port22" {
  security_group_id = aws_security_group.target-node-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "mongo_db" {
  security_group_id = aws_security_group.target-node-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 27017
  to_port           = 27017
}

# Egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.target-node-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 instance
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

resource "aws_instance" "target-node-db-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_target-node-db
  key_name = var.key_name_target-node-db
  vpc_security_group_ids = [aws_security_group.target-node-db-sg.id]

  tags = {
    Name = var.Name_target-node-db
  }
}