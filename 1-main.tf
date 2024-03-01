# ------
# VPC
# ------

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
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

# ----------------
# Public Subnets
# ----------------

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnets)
 vpc_id            = aws_vpc.this.id
 cidr_block        = element(var.public_subnets, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true
 
  tags = {
    Name = "${var.environment}-public_subnets_${count.index + 1}"
    environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.public_route_tables[*].id, count.index)  
}

# ---------------
# Public Routes
# ---------------

resource "aws_route_table" "public_route_tables" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = local.route
    content {   
      cidr_block      = route.value.cidr_block      
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)      
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
    
  }

  tags = {
    Name = "${var.environment}-public_route_table_${count.index + 1}"
    environment = var.environment
  }

  depends_on = [ aws_internet_gateway.this ]
}  

# ----------------
# Private Subnets
# ----------------

resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnets)
 vpc_id            = aws_vpc.this.id
 cidr_block        = element(var.private_subnets, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = false
 
  tags = {
    Name = "${var.environment}-private_subnets_${count.index + 1}"
    environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_associations" {
  count = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_tables[*].id, count.index)  
}

# ------------------
# Data Base Subnets
# ------------------

resource "aws_subnet" "data_base_subnets" {
 count             = length(var.data_base_subnets)
 vpc_id            = aws_vpc.this.id
 cidr_block        = element(var.data_base_subnets, count.index)
 availability_zone = element(var.azs, count.index)
 
  tags = {
    Name = "${var.environment}-data_base_subnets_${count.index + 1}"
    environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_associations_data_base" {
  count = length(var.data_base_subnets)
  subnet_id      = element(aws_subnet.data_base_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_tables[*].id, count.index)  
}

# ----------------
# Private Routes
# ----------------

resource "aws_route_table" "private_route_tables" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = local.route_private
    content {   
      cidr_block      = route.value.cidr_block 
      nat_gateway_id  = route.value.nat_gateway_id[count.index]
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)            
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Name = "${var.environment}-private_route_table_${count.index + 1}"
    environment = var.environment
  }

  depends_on = [ aws_nat_gateway.nat_gateway ]
}  

# -------------
# NAT Gateways
# -------------

resource "aws_eip" "nat_elastic_ip" {
  count = length(var.azs)
  tags = {
    Name = "${var.environment}-nat_elastic_ip_${count.index + 1}"       
    environment = var.environment
  }
  depends_on = [ aws_internet_gateway.this ]
}

resource "aws_nat_gateway" "nat_gateway" {
  count =  length(var.azs)   
  allocation_id = element(aws_eip.nat_elastic_ip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = "${var.environment}-nat_gateway_${count.index + 1}"       
    environment = var.environment
  }  
  depends_on = [ aws_eip.nat_elastic_ip ]
}



















