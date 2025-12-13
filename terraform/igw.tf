# Internet Gateway and Public Route Table setup
resource "aws_internet_gateway" "blog_igw" {
  vpc_id = aws_vpc.blog_vpc.id
  tags   = var.igw_tag
}
