# KMS key for EKS cluster encryption
resource "aws_kms_key" "eks_encryption" {
  description             = "KMS key for EKS cluster encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn # This automatically gets the IAM user ARN
          ]
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow EKS Service to use the key"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow EKS Role to use the key"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.eks_admin_role.arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.env}-eks-encryption-key"
  })
}

# KMS Alias
resource "aws_kms_alias" "eks_encryption_alias" {
  name          = "alias/${local.env}-eks-encryption-key"
  target_key_id = aws_kms_key.eks_encryption.key_id
}
