provider "aws" {
  region = var.primary_region_aws

  default_tags {
    tags = merge(local.common_tags, { RegionRole = "primary" })
  }
}
