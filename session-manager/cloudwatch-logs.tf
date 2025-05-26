# KMS Key for CloudWatch Logs 
resource "aws_kms_key" "cloudwatch_encryption" {
  description             = "KMS key for CloudWatch Log Group encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs to use the key"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        Sid    = "Allow EC2 Instance Role to use the key"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.existing_role.arn
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Log Group for Session Logs
resource "aws_cloudwatch_log_group" "session_logs" {
  name              = "/aws/ssm/session-manager/${var.environment}"
  retention_in_days = 90

  # Enable encryption
  kms_key_id = aws_kms_key.cloudwatch_encryption.arn
  tags = {
    Environment = var.environment
  }
}
