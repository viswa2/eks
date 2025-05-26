# Launch Template for Worker Nodes
resource "aws_launch_template" "eks_node_launch_template" {
  name_prefix            = "${local.env}-${local.cluster_name}-node-launch-template"
  vpc_security_group_ids = [aws_security_group.eks_worker_node_sg.id] # Add security group for worker nodes
  key_name               = var.key_name

  user_data = base64encode(<<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
Content-Transfer-Encoding: 7bit

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
/etc/eks/bootstrap.sh '${aws_eks_cluster.eks_cluster.name}'

--==MYBOUNDARY==--
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.env}-${local.cluster_name}-Worker Node"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.env}-node-group"
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  instance_types  = local.instance_types

  launch_template {
    id      = aws_launch_template.eks_node_launch_template.id
    version = "$Latest"
  }

  ami_type      = "AL2023_x86_64_STANDARD"
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = local.desired_size
    max_size     = local.max_size
    min_size     = local.min_size
  }

  # Use common tags
  tags = local.common_tags

  # Add update config for better control over node updates
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only_policy,
    aws_launch_template.eks_node_launch_template,
  ]
}
