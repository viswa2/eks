locals {
  azs = [local.az1, local.az2]
}

# Private Route Table
resource "aws_route_table" "eks_private_rt" {
  count  = 2
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gw[count.index].id
  }
  tags = merge(local.common_tags, {
    Name                              = "${local.env}-eks-private-rt-${local.azs[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# Public Route Table
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = merge(local.common_tags, {
    Name                     = "${local.env}-eks-public-rt"
    "kubernetes.io/role/elb" = "1"
  })
}

# Private Route Table Associations
resource "aws_route_table_association" "private_rt_association" {
  count = 2

  subnet_id      = count.index == 0 ? aws_subnet.private_subnet1.id : aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.eks_private_rt[count.index].id
}

# Public Route Table Associations
resource "aws_route_table_association" "public_rt_association" {
  count = 2

  subnet_id      = count.index == 0 ? aws_subnet.public_subnet1.id : aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.eks_public_rt.id
}