# Security groups

locals {
  app_alb_ingress_cidr_ipv4 = aws_security_group.blog_alb_sg.id
  db_app_ingress_cidr_ipv4 = aws_security_group.app_sg.id
}

#  ALB SECURITY GROUP

resource "aws_security_group" "blog_alb_sg" {
  name        = var.alb_sg_config["name"]
  description = var.alb_sg_config["description"]
  vpc_id      = aws_vpc.blog_vpc.id

  tags = var.alb_sg_config.["tags"]
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {
 
  security_group_id = aws_security_group.blog_alb_sg.id
  for_each = var.alb_ingress
  description = each.value.description
  cidr_ipv4   = each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  
  security_group_id = aws_security_group.blog_alb_sg.id
  for_each = var.alb_egress
  description = each.value.description
  cidr_ipv4   = each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}

#  FLASK APP SECURITY GROUP (EC2/ECS)

resource "aws_security_group" "app_sg" {
  name        = var.app_sg_config["name"]
  description = var.app_sg_config["description"]
  vpc_id      = aws_vpc.blog_vpc.id

  tags = var.app_sg_config["tags"]
}

resource "aws_vpc_security_group_ingress_rule" "app_ingress" {
  # Pass ingress cidr(alb sg)
  security_group_id = aws_security_group.app_sg.id
  for_each = var.app_ingress
  description = each.value.description
  cidr_ipv4   = each.key == "flask" ? local.app_alb_ingress_cidr_ipv4  : each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.app_sg.id
  for_each = var.app_egress
  description = each.value.description
  cidr_ipv4   = each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}

#  MYSQL SECURITY GROUP (PRIVATE DB)
resource "aws_security_group" "mysql_sg" {
  name        = var.db_sg_config["name"]
  description = var.db_sg_config["description"]
  vpc_id      = aws_vpc.main.id

  tags = var.db_sg_config["tags"]
}


resource "aws_vpc_security_group_ingress_rule" "mysql_ingress" {
  # Pass ingress cidr(app sg)
  security_group_id = aws_security_group.mysql_sg.id
  for_each = var.db_ingress
  description = each.value.description
  cidr_ipv4   = each.key == local.db_app_ingress_cidr_ipv4 ? each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "mysql_egress" {
  security_group_id = aws_security_group.mysql_sg.id
  for_each = var.db_egress
  description = each.value.description
  cidr_ipv4   = each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocols
  to_port     = each.value.to_port
}
