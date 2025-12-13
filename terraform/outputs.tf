output "vpc_id" {
  value       = aws_vpc.blog_vpc.id
  description = "Represents the id of the blog vpc"
}

output "vpc_cidr_block" {
  value       = aws_vpc.blog_vpc.cidr_block
  description = "Represents the cidr block of the blog vpc"
}

output "public_blog_subnet_ids" {
  value       = [for pub_subnet in aws_subnet.public_blog_subnet : pub_subnet.id]
  description = "Represents the IDs of the public blog subnets"
}

output "private_app_subnet_ids" {
  value       = [for app_subnet in aws_subnet.private_app_subnet : app_subnet.id]
  description = "Represents the IDs of the private app subnets"
}

output "private_db_subnet_ids" {
  value       = [for db_subnet in aws_subnet.private_db_subnet : db_subnet.id]
  description = "Represents the IDs of the private db subnets"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.blog_igw.id
  description = "Represents the ID associated with the internet gateway ID"
}

output "public_rt_id" {
  value       = aws_route_table.blog_public_rt.id
  description = "Represents the ID associated with the public route table"
}

output "private_rt_ids" {
  value       = { for rt_name, rt in aws_route_table.blog_private_rt : rt_name => rt.id }
  description = "Represents the name, id of the private route tables"
}

output "eip_ids" {
  value       = { for eip_az, eip in aws_eip.ngw_eip : eip_az => eip.id }
  description = "Represents the EIP AZ, EIP ID"
}

output "nat_gateway_ids" {
  value       = { for nat_gw_az, nat_gw in aws_nat_gateway.nat : nat_gw_az => nat_gw.id }
  description = "Represents the NAT AZ, NAT ID"
}

output "alb_security_group_id" {
  value       = aws_security_group.blog_alb_sg.id
  description = "Represents the security group ID of the ALB"
}

output "app_security_group_id" {
  value       = aws_security_group.app_sg.id
  description = "Represents the security group ID of the container"
}

output "db_security_group_id" {
  value       = aws_security_group.mysql_sg.id
  description = "Represents the security group ID of the database"
}

output "ecs_host_security_group_id" {
  value       = aws_security_group.ecs_host_sg.id
  description = "Represents the security group ID of the container's host"
}

output "db_secrets_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "Represents the ARN of the db credentials"
}

output "alb_arn" {
  value       = aws_lb.app_alb.arn
  description = "Represents the ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "Represents the DNS of the ALB"
}

output "alb_target_grp_arn" {
  value       = aws_lb_target_group.blog_tg.arn
  description = "Represents the Target Group ARN of the ALB"
}
