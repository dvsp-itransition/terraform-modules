locals {    
  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this.id
    }
  ]
  
  route_private = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = [aws_nat_gateway.nat_gateway[0].id, aws_nat_gateway.nat_gateway[1].id]
    }
  ]
  
  depends_on = [aws_internet_gateway.this.id, aws_nat_gateway.nat_gateway]  
}

