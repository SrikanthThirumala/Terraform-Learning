resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags ={
    Name=var.vpc_tag
  }
  provider = aws.east-1-region
}

resource "aws_subnet" "dev_subnet-1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr
  tags = {
    Name=var.subnet_tag
  }
  provider = aws.east-1-region
}

resource "aws_s3_bucket" "sri-custom-bucket" {
  bucket = "sri-custom-bucket1121"
  provider = aws.west-2-region
}