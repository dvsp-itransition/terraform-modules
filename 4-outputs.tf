output "vpc_id" {
  value = aws_vpc.this.cidr_block
}

output "private_subnets" {
  value = {
    for key, subnet in aws_subnet.private_subnets : key => subnet.cidr_block
  }
}

output "data_base_subnets" {
  value = {
    for key, subnet in aws_subnet.data_base_subnets : key => subnet.cidr_block
  }
}

output "public_subnets" {
  value = {
    for key, subnet in aws_subnet.public_subnets : key => subnet.cidr_block
  }
}