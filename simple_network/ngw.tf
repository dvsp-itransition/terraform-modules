# elastic IP for NAT gateways
resource "aws_eip" "nat_gateway_eip" {
  for_each = aws_subnet.private_subnets
  tags = {
    Name = "${var.environment}-nat_gateway_eip"       
    environment = var.environment
  }
}

# NAT gateways for private subnets
resource "aws_nat_gateway" "nat_gateway" {
  for_each = aws_subnet.private_subnets  
  depends_on = [ aws_eip.nat_gateway_eip ]

  allocation_id = aws_eip.nat_gateway_eip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.environment}-nat_gateway"       
    environment = var.environment
  }  
}