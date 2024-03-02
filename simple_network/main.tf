resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-VPC"
    environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.environment}-IG"
    environment = var.environment
  }
}

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

# Public Route Table
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

# create elastic IP for NAT gateway
resource "aws_eip" "nat_gateway_eip" {
  for_each = aws_subnet.private_subnets
  tags = {
    Name = "${var.environment}-nat_gateway_eip"       
    environment = var.environment
  }
}

# create NAT gateways for private subnets
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

# create private route tables
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
