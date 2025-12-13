locals {
  list_of_azs = toset([for subnet in values(var.public_blog_subnet) : subnet.availability_zone])
}

# VPC setup
resource "aws_vpc" "blog_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags                 = var.vpc_tag
}

