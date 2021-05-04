# defining the required provider(s) for the module
provider "aws" {
  region = var.region
}

# create the VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true # required for S3 Endpoint

  tags = {
    Name = var.vpc_name
  }
}

# creating two public subnets
resource "aws_subnet" "public" {
  count = 2

  vpc_id     = aws_vpc.this.id
  cidr_block = count.index == 0 ? var.public1_subnet_cidr : var.public2_subnet_cidr

  tags = {
    Name = "public-${count.index+1}-${var.vpc_name}"
  }
}

# creating two private subnets
resource "aws_subnet" "private" {
  count = 2

  vpc_id     = aws_vpc.this.id
  cidr_block = count.index == 0 ? var.private1_subnet_cidr : var.private2_subnet_cidr

  tags = {
    Name = "private-${count.index+1}-${var.vpc_name}"
  }
}

# IGW to the public subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

# The NAT gateway requires a public IP address
resource "aws_eip" "natgw" {
  count = 2

  vpc = true

  tags = {
    Name = "natgw-${count.index+1}-${var.vpc_name}"
  }
}

# Private subnets with internet access require a NAT gateway
resource "aws_nat_gateway" "gw" {
  count = 2

  allocation_id = aws_eip.natgw[count.index].id
  subnet_id     = aws_subnet.private[count.index].id

  tags = {
    Name = "gw-${count.index+1}-${var.vpc_name}"
  }
}

# public subnets communicate through the Internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-${var.vpc_name}"
  }
}

# private subnets communicate through the NAT gateway
resource "aws_route_table" "private" {
  count = 2

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw[count.index].id
  }

  tags = {
    Name = "private-${count.index+1}-${var.vpc_name}"
  }
}

# Assigning the public subnets' default route to the IGW
resource "aws_route_table_association" "public" {
  count = 2

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Assigning the private subnets' default route to the NAT gateways
resource "aws_route_table_association" "private" {
  count = 2

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Limiting S3 access to inter-AWS network
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = setunion([aws_route_table.public.id], aws_route_table.private[*].id)

  tags = {
    Name = "s3-${var.vpc_name}"
  }
}