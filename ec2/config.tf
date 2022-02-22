terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
    cloudflare= {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
