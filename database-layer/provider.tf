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
# Vault provider for fetching secrets from HashiCorp Vault
# This is used in the db-setup module to retrieve the RDS password securely
# Ensure that your Vault provider is properly configured with the necessary authentication method (e.g., token, AppRole, etc.) and that it has access to the secrets path used in the db-setup module.
# For example, if you're using token authentication, you might set the VAULT_TOKEN environment variable before running Terraform:
# In this project we have setup Vault on localhost for demonstration purposes, but in a production environment, you would typically point this to your Vault server's address and configure authentication accordingly.
# For local development, you can run Vault in dev mode using the command `vault server -dev` and it will provide you with a root token that you can use for authentication. Remember to replace this with a more secure setup for production use.
# I have left the provider empty here since i will be using the VAULT_TOKEN environment variable for authentication, but you can also configure it directly in the provider block if needed.
provider "vault" {}