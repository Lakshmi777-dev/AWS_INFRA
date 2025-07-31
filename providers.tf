terraform {
  required_version = ">= 1.7.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.7.3"
    }
  }
  backend "s3" {
    bucket         = "rabiesevin-prod-terraformstate"
    key            = "rabiesevin-state/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}

provider "aws" {
  region     = var.aws_region
}
