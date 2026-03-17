# 1. The S3 Bucket to hold the State File
resource "aws_s3_bucket" "terraform_state" {

  bucket = "azam-tfstate-storage-2026"

  # This prevents Terraform from accidentally deleting the bucket
  lifecycle {
    prevent_destroy = true
  }
}

# 2. Enable Versioning so we can recover old state files
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Encryption to protect sensitive data in the state
resource "aws_s3_bucket_server_side_encryption_configuration" "state_crypto" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # This is case-sensitive!

  attribute {
    name = "LockID"
    type = "S"
  }
}