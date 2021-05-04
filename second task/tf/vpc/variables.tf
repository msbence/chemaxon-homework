variable "region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "vpc_name" {
  description = "Used as identifier for the VPC and it's related resources"
  type = string
  default = "tf-vpc"
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public1_subnet_cidr" {
  description = "CIDR of the first public subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "public2_subnet_cidr" {
  description = "CIDR of the second public subnet"
  type = string
  default = "10.0.2.0/24"
}

variable "private1_subnet_cidr" {
  description = "CIDR of the first private subnet"
  type = string
  default = "10.0.11.0/24"
}

variable "private2_subnet_cidr" {
  description = "CIDR of the second private subnet"
  type = string
  default = "10.0.12.0/24"
}