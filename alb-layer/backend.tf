terraform {
  backend "s3" {
    bucket         = "azam-tfstate-storage-2026"
    key            = "enterprise/alb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking-table"
    encrypt        = true
  }
}