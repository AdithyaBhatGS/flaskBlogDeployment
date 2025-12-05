# Usage of Terraform version and AWS provider
terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "Flask Blog App"
      Environment = "Dev"
      Terraform   = "true"
    }
  }
}

