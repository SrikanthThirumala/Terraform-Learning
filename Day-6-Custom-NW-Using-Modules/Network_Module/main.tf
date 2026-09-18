resource "aws_vpc" "sri-custom-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_subnet" "sri_public_subnet-1" {
  vpc_id     = aws_vpc.sri-custom-vpc.id
  cidr_block = var.subnet_1_cidr
  tags = {
    Name = var.subnet_1_tag
  }
}

resource "aws_subnet" "sri_public_subnet-2" {
  vpc_id     = aws_vpc.sri-custom-vpc.id
  cidr_block = var.subnet_2_cidr
  tags = {
    Name = var.subnet_2_tag
  }
}

resource "aws_internet_gateway" "sri_igw" {
  vpc_id = aws_vpc.sri-custom-vpc.id
  tags = {
    Name=var.igw_name
  }
  
}

resource "aws_route_table" "sri_pub_rt" {
  vpc_id = aws_vpc.sri-custom-vpc.id
  route {
    cidr_block = var.pub_rt_cidr
    gateway_id = aws_internet_gateway.sri_igw.id
  }

  tags = {
    Name=var.pub_rt_name
  }
}

resource "aws_route_table_association" "sri-pub-rt-assoc-1" {
  route_table_id = aws_route_table.sri_pub_rt.id
  subnet_id = aws_subnet.sri_public_subnet-1.id

}

resource "aws_route_table_association" "sri-pub-rt-assoc-2" {
  route_table_id = aws_route_table.sri_pub_rt.id
  subnet_id = aws_subnet.sri_public_subnet-2.id
  
}


resource "aws_security_group" "sri-ec2-sg" {
  vpc_id = aws_vpc.sri-custom-vpc.id
  name   = var.ec2_sec_name
  tags = {
    Name=var.ec2_sec_name
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic"
 
  }


}