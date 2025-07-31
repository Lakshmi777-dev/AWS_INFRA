output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_eip" {
  description = "Elastic IP of the NAT Gateway"
  value       = var.create_nat_gateway && length(aws_eip.nat_gateway) > 0 ? aws_eip.nat_gateway[0].public_ip : null
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.create_nat_gateway && length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].id : null
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
