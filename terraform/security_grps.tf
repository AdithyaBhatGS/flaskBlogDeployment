# Security groups

#  ALB SECURITY GROUP
resource "aws_security_group" "blog_alb_sg" {
  name        = var.alb_sg_config["alb_sg_config"].name
  description = var.alb_sg_config["alb_sg_config"].description
  vpc_id      = aws_vpc.blog_vpc.id

  tags = var.alb_sg_config["alb_sg_config"].tags
}

# ALB Ingress -> http
resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {

  security_group_id = aws_security_group.blog_alb_sg.id
  for_each          = var.alb_ingress
  description       = each.value.description
  cidr_ipv4         = each.value.cidr_blocks
  from_port         = each.value.from_port
  ip_protocol       = each.value.protocols
  to_port           = each.value.to_port
}

# ALB Egress -> all outbound
resource "aws_vpc_security_group_egress_rule" "alb_egress" {

  security_group_id            = aws_security_group.blog_alb_sg.id
  for_each                     = var.alb_egress
  description                  = each.value.description
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.protocols
  to_port                      = each.value.to_port
}


# EC2 Host SECURITY GROUP
resource "aws_security_group" "ecs_host_sg" {
  name        = "${var.ecs_cluster_name}-host-sg"
  description = var.ecs_host_sg_description
  vpc_id      = aws_vpc.blog_vpc.id

  tags = {
    Name = "${var.ecs_cluster_name}-host-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_host_outbound" {
  for_each          = var.ecs_host_egress
  security_group_id = aws_security_group.ecs_host_sg.id
  description       = each.value.description

  cidr_ipv4 = each.value.cidr_blocks

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocols

}

resource "aws_vpc_security_group_ingress_rule" "ecs_host_inbound" {
  for_each          = var.ecs_host_ingress
  security_group_id = aws_security_group.ecs_host_sg.id
  description       = each.value.description

  referenced_security_group_id = aws_security_group.app_sg.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocols
}


#  FLASK APP SECURITY GROUP (Containers on EC2/ECS)
resource "aws_security_group" "app_sg" {
  name        = var.app_sg_config["app_sg_config"].name
  description = var.app_sg_config["app_sg_config"].description
  vpc_id      = aws_vpc.blog_vpc.id

  tags = var.app_sg_config["app_sg_config"].tags
}


# App Ingress -> from ALB on port 5000
resource "aws_vpc_security_group_ingress_rule" "app_ingress" {
  for_each          = var.app_ingress
  security_group_id = aws_security_group.app_sg.id
  description       = each.value.description

  # ALB → APP (SG rule)
  referenced_security_group_id = aws_security_group.blog_alb_sg.id


  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocols
}

# App Egress -> all outbound
resource "aws_vpc_security_group_egress_rule" "app_egress" {
  for_each          = var.app_egress
  security_group_id = aws_security_group.app_sg.id
  description       = each.value.description

  cidr_ipv4 = each.value.cidr_blocks

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocols
}

#  MYSQL SECURITY GROUP (PRIVATE DB)
resource "aws_security_group" "mysql_sg" {
  name        = var.db_sg_config["db_sg_config"].name
  description = var.db_sg_config["db_sg_config"].description
  vpc_id      = aws_vpc.blog_vpc.id

  tags = var.db_sg_config["db_sg_config"].tags
}


# DB Ingress -> from APP on port 3306
resource "aws_vpc_security_group_ingress_rule" "mysql_ingress" {
  for_each          = var.db_ingress
  security_group_id = aws_security_group.mysql_sg.id
  description       = each.value.description

  # APP → DB (SG rule)
  referenced_security_group_id = aws_security_group.app_sg.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocols
}


