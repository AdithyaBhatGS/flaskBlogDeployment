

terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


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

