output "vpc_id" {
  value = aws_vpc.demo-VPC.cidr_block
}