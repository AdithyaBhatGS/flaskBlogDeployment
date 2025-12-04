# VPC setup

resource "aws_vpc" "blog_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Public Subnet setup

resource "aws_subnet" "public_blog_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.public_blog_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

resource "aws_internet_gateway" "blog_igw" {
  vpc_id = aws_vpc.blog_vpc.id
}

resource "aws_route_table" "blog_public_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  tags   = var.blog_public_rt_tag
}

resource "aws_route" "blog_public_route" {
  route_table_id         = aws_route_table.blog_public_rt.id
  destination_cidr_block = var.pub_dest_cidr
  gateway_id             = aws_internet_gateway.blog_igw.id
}

resource "aws_route_table_association" "blog_public_rt_subnet_association" {
  for_each       = aws_subnet.public_blog_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.blog_public_rt.id
}


# NAT setup

resource "aws_eip" "ngw_eip" {
  tags = var.eip_tag
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_blog_subnet["public_blog_subnet1"].id

  tags = var.nat_tag

  depends_on = [aws_internet_gateway.blog_igw]
}


# Private Subnet setup

resource "aws_subnet" "private_blog_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.private_blog_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}


resource "aws_route_table" "blog_private_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  tags   = var.blog_private_rt_tag
}

resource "aws_route" "blog_private_route" {
  route_table_id         = aws_route_table.blog_priavte_rt.id
  destination_cidr_block = var.pub_dest_cidr
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "blog_private_rt_subnet_association" {
  for_each       = aws_subnet.private_blog_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.blog_private_rt.id
}

