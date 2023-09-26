terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">= 4.0"
      configuration_aliases = [aws.us-east-1]
    }
  }
}