resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags ={
    Name=var.vpc_tag
  }
}

resource "aws_subnet" "dev_subnet-1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr
  tags = {
    Name=var.subnet_tag
  }
}