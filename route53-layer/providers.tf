provider "aws" {
  region = var.primary_region_aws

  default_tags {
    tags = local.common_tags
  }
}
