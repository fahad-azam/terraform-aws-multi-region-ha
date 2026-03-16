locals {
  # These match the middle segments of your SSM paths
  regions     = ["primary", "standby"]
  subnet_keys = ["private_db1", "private_db2"]
  environment = lower(var.environment)
}