output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "public_subnet_id" {
  description = "ID of the public subnet(s)"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arn" {
  description = "ARN of the public subnet(s)"
  value       = aws_subnet.public[*].arn
}

output "private_subnet_id" {
  description = "ID of the private subnet(s)"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arn" {
  description = "ARN of the private subnet(s)"
  value       = aws_subnet.private[*].arn
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "s3_vpc_endpoint_arn" {
  description = "ARN of the S3 VPC Endpoint"
  value       = aws_vpc_endpoint.s3.arn
}
