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
# I have left the provider empty here since i will be using the VAULT_TOKEN environment variable for authentication, but you can also configure it directly in the provider block if needed.
provider "vault" {}