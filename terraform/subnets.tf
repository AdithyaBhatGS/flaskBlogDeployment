# Public Subnet setup - 2 public subnets, 1 in each AZ
resource "aws_subnet" "public_blog_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.public_blog_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = each.value.tags
}

# Private Subnet for app - 2 private subnets, 1 in each AZ
resource "aws_subnet" "private_app_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.private_app_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags                    = each.value.tags
}

# Private Subnet for db - 2 private subnets, 1 in each AZ
resource "aws_subnet" "private_db_subnet" {
  vpc_id                  = aws_vpc.blog_vpc.id
  for_each                = var.private_db_subnet
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags                    = each.value.tags
}
