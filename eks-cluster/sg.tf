# Control Plane Security Group for EKS
resource "aws_security_group" "eks_control_plane_sg" {
  description = "Security group for EKS control plane"
  name        = "${local.cluster_full_name}-control-plane-sg"
  vpc_id      = aws_vpc.eks_vpc.id

  # Allow all egress traffic
  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name                                               = "${local.cluster_full_name}-control-plane-sg"
    "kubernetes.io/cluster/${local.cluster_full_name}" = "owned"
  })
}

# Worker Node Security Group for EKS
resource "aws_security_group" "eks_worker_node_sg" {
  name   = "${local.cluster_full_name}-worker-node-sg"
  vpc_id = aws_vpc.eks_vpc.id

  # Allow all egress traffic
  egress {
    description = "Node to node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this to specific IPs
  }

  tags = merge(local.common_tags, {
    Name                                               = "${local.cluster_full_name}-worker-node-sg"
    "kubernetes.io/cluster/${local.cluster_full_name}" = "owned"
  })
}

# Control plane to worker node rules
resource "aws_security_group_rule" "control_plane_to_worker" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_worker_node_sg.id
  security_group_id        = aws_security_group.eks_control_plane_sg.id
  description              = "Allow control plane to communicate with worker nodes"
}

# Worker node to control plane rules
resource "aws_security_group_rule" "worker_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
  security_group_id        = aws_security_group.eks_worker_node_sg.id
  description              = "Allow worker nodes to communicate with control plane"
}

# Worker node to worker node rules
resource "aws_security_group_rule" "worker_node_internal" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_worker_node_sg.id
  security_group_id        = aws_security_group.eks_worker_node_sg.id
  description              = "Allow worker nodes to communicate with each other"
}

# Allow worker nodes kubelet access
resource "aws_security_group_rule" "worker_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
  security_group_id        = aws_security_group.eks_worker_node_sg.id
  description              = "Allow kubelet access from control plane"
}
