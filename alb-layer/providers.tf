provider "aws" {
  region = var.primary_region_aws

  default_tags {
    tags = merge(local.common_tags, { RegionRole = "primary" })
  }
}

provider "aws" {
  alias  = "standby_region_aws"
  region = var.standby_region_aws

  default_tags {
    tags = merge(local.common_tags, { RegionRole = "standby" })
  }
}
