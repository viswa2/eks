# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.env}-${local.cluster_name}"
  role_arn = aws_iam_role.eks_admin_role.arn
  version  = local.eks_version

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    subnet_ids              = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
    security_group_ids      = [aws_security_group.eks_control_plane_sg.id]
  }
  # Add the encryption configuration here
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_encryption.arn
    }
    resources = ["secrets"]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Enable control plane logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Use common tags
  tags = local.common_tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_admin_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]
}

