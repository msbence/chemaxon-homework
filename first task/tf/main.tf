terraform {
  required_version = "~> 0.15.1"

  required_providers {
    aws = {
      version = "3.38.0"
      source = "hashicorp/aws"
    }

    namecheap = {
      source  = "robgmills/namecheap"
      version = "1.7.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "namecheap" {}
