# Route table for public subnet
resource "aws_route_table" "blog_public_rt" {
  vpc_id = aws_vpc.blog_vpc.id
  tags   = var.blog_public_rt_tag
}

# Route for igw from public subnet
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

# Private App Route Table setup
resource "aws_route_table" "app_private_rt" {
  vpc_id   = aws_vpc.blog_vpc.id
  for_each = local.list_of_azs
  tags     = var.app_private_rt_tag
}

resource "aws_route" "app_private_route" {
  for_each               = aws_nat_gateway.nat
  route_table_id         = aws_route_table.app_private_rt[each.key].id
  destination_cidr_block = var.pub_dest_cidr
  nat_gateway_id         = each.value.id
}

# Associations of private app subnets with private route table
resource "aws_route_table_association" "app_private_rt_subnet_association" {
  for_each       = aws_subnet.private_app_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app_private_rt[each.value.availability_zone].id
}

# Private DB Route Table setup
resource "aws_route_table" "db_private_rt" {
  vpc_id   = aws_vpc.blog_vpc.id
  for_each = local.list_of_azs
  tags     = var.db_private_rt_tag
}

# Associations of private app subnets with private route table
resource "aws_route_table_association" "db_private_rt_subnet_association" {
  for_each       = aws_subnet.private_db_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.db_private_rt[each.value.availability_zone].id
}

