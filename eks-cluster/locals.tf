locals {
  cluster_name   = var.cluster_name
  region         = "us-east-2"
  az1            = "us-east-2a"
  az2            = "us-east-2b"
  env            = var.environment
  eks_version    = "1.30"
  instance_types = ["t3.medium"]
  min_size       = 1
  max_size       = 3
  desired_size   = 1

  # Common tags
  common_tags = {
    Environment = local.env
    Terraform   = "true"
    Project     = "eks-cluster"
  }

  # Cluster full name
  cluster_full_name = "${local.env}-${local.cluster_name}"
}
