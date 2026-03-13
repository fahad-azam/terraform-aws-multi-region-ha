# terraform {
#   required_version = ">= 1.5.0, < 2.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0" # Note: AWS Provider v6.0 isn't out yet, ~> 5.0 is the current stable
#     }
#     vault = {
#       source  = "hashicorp/vault"
#       version = "~> 3.25.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.6.0"
#     }
#   }
# }
terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Matches your 6.36.0
      configuration_aliases = [aws.standby_region_aws]
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