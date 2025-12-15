# Provider 
 provider "aws" {
  region = var.region_app
 }

# Custom VPC
 resource "aws_vpc" "my_own_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_tag_name
  }
 }

# Subnets
  # Public
 resource "aws_subnet" "custom_public_subnet" {
  vpc_id = aws_vpc.my_own_vpc.id
  cidr_block = var.vpc_public_sn_cidr
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.vpc_public_sn_tag_name
  }
 }

  # Private
 resource "aws_subnet" "custom_private_subnet" {
  vpc_id = aws_vpc.my_own_vpc.id
  cidr_block = var.vpc_private_sn_cidr
  availability_zone = "eu-west-1b"
 
  tags = {
    Name = var.vpc_private_sn_tag_name
  }
 }

# Internet Gateway
resource "aws_internet_gateway" "allow_ig_pub_sn" {
  vpc_id = aws_vpc.my_own_vpc.id

  tags = {
    Name = var.vpc_custom_ig
  }
}

# Route Tables
  # Public RT
resource "aws_route_table" "custom_pub_rt" {
  vpc_id = aws_vpc.my_own_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.allow_ig_pub_sn.id
  }

  tags = {
    Name = var.vpc_rt_custom_public
  }
}

  # Public RT Associations
resource "aws_route_table_association" "custom_rt_pub_assoc" {
  subnet_id = aws_subnet.custom_public_subnet.id
  route_table_id = aws_route_table.custom_pub_rt.id
}

# Security group
resource "aws_security_group" "app_deploy_tf_sg" {  
  name        = var.sg_name_app
  description = var.sg_description_app
  vpc_id      = aws_vpc.my_own_vpc.id

  tags = { 
    Name = var.tag_name_app 
    }
}

  # Ingress rules
    # Allow port 22
resource "aws_vpc_security_group_ingress_rule" "app_allow_port22" {
  security_group_id = aws_security_group.app_deploy_tf_sg.id
  cidr_ipv4         = "45.146.10.181/32"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

    # Allow port 3000
resource "aws_vpc_security_group_ingress_rule" "app_allow_port3000" {
  security_group_id = aws_security_group.app_deploy_tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 3000
  to_port           = 3000
}

    # Allow port 80
resource "aws_vpc_security_group_ingress_rule" "app_allow_port80" {
  security_group_id = aws_security_group.app_deploy_tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

  # Egress rules
    # Allow all traffic
resource "aws_vpc_security_group_egress_rule" "app_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.app_deploy_tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 instance
resource "aws_instance" "app_deploy_instance" {
  ami                         = var.app_ami_id_app
  instance_type               = var.instance_type_app
  subnet_id = aws_subnet.custom_public_subnet.id
  key_name                    = var.key_name_app
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_deploy_tf_sg.id]

    user_data = templatefile("${path.module}/run-app.sh.tftpl", {
    db_ip = aws_instance.db_deploy_instance.private_ip
  })

  tags = { 
    Name = var.Name_app 
    }
}
