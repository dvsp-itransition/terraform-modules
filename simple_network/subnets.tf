resource "aws_subnet" "public_subnets" {
  for_each = local.subnet_cidr_blocks

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.public
  availability_zone = each.key
  map_public_ip_on_launch = true  
  tags = {
    Name = "${var.environment}-public-subnet"
    environment = var.environment
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = local.subnet_cidr_blocks

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.private
  availability_zone = each.key

  tags = {
    Name = "${var.environment}-private-subnet"
    environment = var.environment
  }
}