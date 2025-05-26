output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.eks_control_plane_sg.id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS worker nodes"
  value       = aws_security_group.eks_worker_node_sg.id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_iam_role.eks_admin_role.arn
}

output "node_group_iam_role_arn" {
  description = "IAM role ARN of the EKS node group"
  value       = aws_iam_role.eks_worker_node_role.arn
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = aws_eip.eks_nat_eip[*].public_ip
}

output "control_plane_sg_id" {
  description = "ID of the control plane security group"
  value       = aws_security_group.eks_control_plane_sg.id
}

output "worker_node_sg_id" {
  description = "ID of the worker node security group"
  value       = aws_security_group.eks_worker_node_sg.id
}
