# KMS Key for S3 Encryption
resource "aws_kms_key" "s3_encryption" {
  description         = "KMS key for S3 Bucket encryption"
  enable_key_rotation = true
}
# S3 Bucket for Session Logs
resource "aws_s3_bucket" "session_logs" {
  bucket = "nifi-prod-session-logs-${data.aws_caller_identity.current.account_id}"
  tags = {
    Environment = var.environment
  }
}

# Enable S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "session_logs" {
  bucket = aws_s3_bucket.session_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 Bucket Lifecycle Configuration 
resource "aws_s3_bucket_lifecycle_configuration" "session_logs" {
  bucket = aws_s3_bucket.session_logs.id

  rule {
    id     = "expire_logs"
    status = "Enabled"
    expiration {
      days = 365
    }
  }
}

# Add separate versioning configuration
resource "aws_s3_bucket_versioning" "session_logs" {
  bucket = aws_s3_bucket.session_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}
