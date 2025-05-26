# Additional policy for Session Manager encryption and S3 access
resource "aws_iam_role_policy" "session_manager_encryption" {
  name = "session-manager-encryption-${var.instance_id}"
  role = data.aws_iam_role.existing_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.s3_encryption.arn,
          aws_kms_key.cloudwatch_encryption.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketLocation",
          "s3:GetBucketEncryption"
        ]
        Resource = [
          "${aws_s3_bucket.session_logs.arn}/*",
          aws_s3_bucket.session_logs.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "${aws_cloudwatch_log_group.session_logs.arn}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:PutParameter"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/session-manager/*"
        ]
      }
    ]
  })
}