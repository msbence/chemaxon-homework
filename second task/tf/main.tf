terraform {
  required_version = "~> 0.15.1"

  required_providers {
    aws = {
      version = "3.38.0"
      source = "hashicorp/aws"
    }
  }
}


# sample module usage
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

# expose some output from the module
output "vpc_arn" {
  value = module.vpc.vpc_arn
}