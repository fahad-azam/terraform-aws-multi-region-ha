resource "aws_s3_bucket" "primary_artifact" {
  bucket = "${local.name_prefix}-${var.primary_region_aws}-artifacts"
}

resource "aws_s3_bucket" "primary_data" {
  bucket = "${local.name_prefix}-${var.primary_region_aws}-data"
}

resource "aws_s3_bucket" "standby_artifact" {
  provider = aws.standby_region_aws
  bucket   = "${local.name_prefix}-${var.standby_region_aws}-artifacts"
}

resource "aws_s3_bucket" "standby_data" {
  provider = aws.standby_region_aws
  bucket   = "${local.name_prefix}-${var.standby_region_aws}-data"
}

resource "aws_s3_bucket_public_access_block" "primary_artifact" {
  bucket                  = aws_s3_bucket.primary_artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "primary_data" {
  bucket                  = aws_s3_bucket.primary_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "standby_artifact" {
  provider                = aws.standby_region_aws
  bucket                  = aws_s3_bucket.standby_artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "standby_data" {
  provider                = aws.standby_region_aws
  bucket                  = aws_s3_bucket.standby_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "primary_artifact" {
  bucket = aws_s3_bucket.primary_artifact.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "primary_data" {
  bucket = aws_s3_bucket.primary_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "standby_artifact" {
  provider = aws.standby_region_aws
  bucket   = aws_s3_bucket.standby_artifact.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "standby_data" {
  provider = aws.standby_region_aws
  bucket   = aws_s3_bucket.standby_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary_artifact" {
  bucket = aws_s3_bucket.primary_artifact.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary_data" {
  bucket = aws_s3_bucket.primary_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "standby_artifact" {
  provider = aws.standby_region_aws
  bucket   = aws_s3_bucket.standby_artifact.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "standby_data" {
  provider = aws.standby_region_aws
  bucket   = aws_s3_bucket.standby_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "primary_application_artifact" {
  bucket       = aws_s3_bucket.primary_artifact.id
  key          = local.app_artifact_key
  source       = local.app_artifact_file_path
  etag         = filemd5(local.app_artifact_file_path)
  content_type = "text/x-python"
}

resource "aws_s3_object" "standby_application_artifact" {
  provider     = aws.standby_region_aws
  bucket       = aws_s3_bucket.standby_artifact.id
  key          = local.app_artifact_key
  source       = local.app_artifact_file_path
  etag         = filemd5(local.app_artifact_file_path)
  content_type = "text/x-python"
}
