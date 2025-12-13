# NAT setup

# Elastic IP for NAT Gateway
resource "aws_eip" "ngw_eip" {
  domain   = "vpc"
  for_each = local.list_of_azs
  tags = {
    Name = "${var.eip_tag}-${each.key}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  for_each = {
    for name, subnet in aws_subnet.public_blog_subnet :
    subnet.availability_zone => subnet
    if contains(local.list_of_azs, subnet.availability_zone)
  }

  allocation_id = aws_eip.ngw_eip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.nat_tag}-${each.key}"
  }

  depends_on = [aws_internet_gateway.blog_igw]
}
