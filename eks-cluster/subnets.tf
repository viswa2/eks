locals {
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

# Private Subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = local.private_subnet_cidrs[0]
  availability_zone       = local.az1
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                                                       = "${local.env}-eks-private-subnet-${local.az1}"
    "kubernetes.io/role/internal-elb"                          = "1"
    "kubernetes.io/cluster/${local.cluster_full_name}"         = "owned"
    "kubernetes.io/cluster/${local.env}-${local.cluster_name}" = "shared"
    Type                                                       = "private"
  })
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = local.private_subnet_cidrs[1]
  availability_zone       = local.az2
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                                                       = "${local.env}-eks-private-subnet-${local.az2}"
    "kubernetes.io/role/internal-elb"                          = "1"
    "kubernetes.io/cluster/${local.cluster_full_name}"         = "owned"
    "kubernetes.io/cluster/${local.env}-${local.cluster_name}" = "shared"
    Type                                                       = "private"
  })
}

# Public Subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = local.public_subnet_cidrs[0]
  availability_zone       = local.az1
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                                                       = "${local.env}-eks-public-subnet-${local.az1}"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/cluster/${local.cluster_full_name}"         = "owned"
    "kubernetes.io/cluster/${local.env}-${local.cluster_name}" = "shared"
    Type                                                       = "public"
  })
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = local.public_subnet_cidrs[1]
  availability_zone       = local.az2
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                                                       = "${local.env}-eks-public-subnet-${local.az2}"
    "kubernetes.io/role/elb"                                   = "1"
    "kubernetes.io/cluster/${local.cluster_full_name}"         = "owned"
    "kubernetes.io/cluster/${local.env}-${local.cluster_name}" = "shared"
    Type                                                       = "public"
  })
}