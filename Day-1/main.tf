resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags ={
    Name="Sri-VPC-1"
  }
}