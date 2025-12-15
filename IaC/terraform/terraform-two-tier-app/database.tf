# Security group
resource "aws_security_group" "db_deploy_tf_sg" {  
  name        = var.sg_name_db
  description = var.sg_description_db
  vpc_id      = aws_vpc.my_own_vpc.id

  tags = { 
    Name = var.tag_name_db 
    }
}

  # Ingress rules
    # Port 22
resource "aws_vpc_security_group_ingress_rule" "allow_port22" {
  security_group_id = aws_security_group.db_deploy_tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

    # MongoDB
resource "aws_vpc_security_group_ingress_rule" "db_only_from_app" {
  security_group_id = aws_security_group.db_deploy_tf_sg.id
  referenced_security_group_id = aws_security_group.app_deploy_tf_sg.id
  ip_protocol       = "tcp"
  from_port         = 27017
  to_port           = 27017
}

  # Egress rules
    # Allow All Traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.db_deploy_tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 instance
resource "aws_instance" "db_deploy_instance" {
  ami                         = var.app_ami_id_db
  instance_type               = var.instance_type_db
  subnet_id = aws_subnet.custom_private_subnet.id
  key_name                    = var.key_name_db
  vpc_security_group_ids      = [aws_security_group.db_deploy_tf_sg.id]

  tags = { 
    Name = var.Name_db 
    }
}

