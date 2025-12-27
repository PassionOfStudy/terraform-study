# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "public_subnet_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private_2.id
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "security_group_arn" {
  description = "ARN of the web security group"
  value       = aws_security_group.web.arn
}

# EC2 Instance Outputs
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "ec2_instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.example.arn
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "ec2_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.example.private_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.example.public_dns
}

output "ec2_instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.example.private_dns
}

# Summary Output
output "summary" {
  description = "Summary of created resources"
  value = {
    vpc_id          = aws_vpc.main.id
    public_subnets  = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    private_subnets = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    instance_id     = aws_instance.example.id
    instance_ip     = aws_instance.example.public_ip
  }
}

