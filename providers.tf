terraform {
  required_version = ">= 1.7.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.7.3"
    }
  }
  backend "s3" {
    bucket         = "testsarthi"
    key            = "sarthi-state/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}

# Not recommended — security risk
provider "aws" {
  access_key = "AKIAZK4TUP7QXW6KBMOB"
  secret_key = "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"
  region     = "ap-south-1"
}

