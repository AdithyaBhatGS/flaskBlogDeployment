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
  region                   = var.aws_region
  shared_credentials_files = ["${var.aws_cred_path}"]
  default_tags {
    tags = {
      Project     = "Flask Blog App"
      Environment = "Dev"
      Terraform   = "true"
    }
  }
}

