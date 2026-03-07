data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = local.state_bucket
    key    = local.network_key
    region = var.primary_region
  }
}