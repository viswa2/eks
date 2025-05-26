# NAT EIP
resource "aws_eip" "eks_nat_eip" {
  count  = 2
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = "${local.env}-eks-nat-eip-${count.index + 1}"
  })
}

# Nat Gateway
resource "aws_nat_gateway" "eks_nat_gw" {
  count         = 2
  allocation_id = aws_eip.eks_nat_eip[count.index].id
  subnet_id     = count.index == 0 ? aws_subnet.public_subnet1.id : aws_subnet.public_subnet2.id

  tags = merge(local.common_tags, {
    Name = "${local.env}-eks-nat-gw-${local.azs[count.index]}"
    AZ   = local.azs[count.index]
  })
  depends_on = [aws_internet_gateway.eks_igw]
}
