
terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.standby_region_aws]
      version = "~> 6.0" # Matches your 6.36.0
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0" # Will allow your 5.8.0
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0" # Will allow your 3.8.1
    }
  }
}