# Public Route Tables
resource "aws_route_table" "public_route_tables" {
  for_each = aws_subnet.public_subnets
  vpc_id = aws_vpc.this.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.environment}-public_route_table"    
    environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  for_each = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_tables[each.key].id    
}

# Private route tables
resource "aws_route_table" "private_route_tables" {
  for_each = aws_subnet.private_subnets
  vpc_id = aws_vpc.this.id
  depends_on = [ aws_eip.nat_gateway_eip ]

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = {
    Name = "${var.environment}-private_route_table"         
    environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_associations" {
  for_each = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_tables[each.key].id  
}
