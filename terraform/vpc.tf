# VPC setup
resource "aws_vpc" "blog_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Public Subnet setup - 2 public subnets, 1 in each AZ
resource "aws_subnet" "public_blog_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.public_blog_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

# Internet Gateway and Public Route Table setup
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

# Associations of public subnets with public route table
resource "aws_route_table_association" "blog_public_rt_subnet_association" {
  for_each       = aws_subnet.public_blog_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.blog_public_rt.id
}


# NAT setup

# Elastic IP for NAT Gateway
resource "aws_eip" "ngw_eip" {
  tags = var.eip_tag
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_blog_subnet["public_blog_subnet1"].id

  tags = var.nat_tag

  depends_on = [aws_internet_gateway.blog_igw]
}


# Private Subnet setup - 2 private subnets, 1 in each AZ
resource "aws_subnet" "private_blog_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.private_blog_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

# Private Route Table setup
resource "aws_route_table" "blog_private_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  tags   = var.blog_private_rt_tag
}

resource "aws_route" "blog_private_route" {
  route_table_id         = aws_route_table.blog_priavte_rt.id
  destination_cidr_block = var.pub_dest_cidr
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associations of private subnets with private route table
resource "aws_route_table_association" "blog_private_rt_subnet_association" {
  for_each       = aws_subnet.private_blog_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.blog_private_rt.id
}

