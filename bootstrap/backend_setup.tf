# This file only sets up the S3 bucket and DynamoDB table for Terraform state management and locking.
# To acually use this i need to define backend configuration on each layer pointing to this S3 bucket and DynamoDB table. 

resource "aws_s3_bucket" "terraform_state" {
  bucket = "azam-tfstate-storage-2026"
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "state_crypto" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" 
  attribute {
    name = "LockID"
    type = "S"
  }
}