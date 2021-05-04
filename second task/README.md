# VPC Terraform module

## Description

A VPC with internet access

- 4 subnets
- 2 subnets public.
- 2 subnets private with internet access.
- Make sure access to S3 is not leaving the AWS network.

## Example usage

```terraform
module "vpc" {
  source = "./vpc"

  region = "eu-central-1"
  vpc_name = "terraform-vpc"
  vpc_cidr = "10.0.0.0/16"
  public1_subnet_cidr = "10.0.1.0/24"
  public2_subnet_cidr = "10.0.2.0/24"
  private1_subnet_cidr = "10.0.101.0/24"
  private2_subnet_cidr = "10.0.102.0/24"
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}
```
