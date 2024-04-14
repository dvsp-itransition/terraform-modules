output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = [
    for subnet in aws_subnet.public_subnets : subnet.cidr_block
  ]
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "data_base_subnets" {
  value = aws_subnet.data_base_subnets.*.cidr_block
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "data_base_subnets_ids" {
  value = aws_subnet.data_base_subnets.*.id
}


