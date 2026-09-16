resource "aws_vpc" "sri_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name=var.vpc_name
  }
}

resource "aws_subnet" "subnet-1-pub" {
  vpc_id = aws_vpc.sri_vpc.id
  cidr_block = var.pub_subnet_cidr
  tags = {
    Name=var.pub_subnet_name
  }
}

resource "aws_internet_gateway" "sri-igw" {
  
  vpc_id = aws_vpc.sri_vpc.id
  tags = {
    Name=var.igw_name
  }
  
}

resource "aws_route_table" "sri-pub-rt" {
  vpc_id = aws_vpc.sri_vpc.id
  
  route  {
    
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sri-igw.id
  }
  tags = {
    Name="sri-pub-rt-table"
  }
}

resource "aws_route_table_association" "sri-pub-assoc" {
  route_table_id = aws_route_table.sri-pub-rt.id
  subnet_id = aws_subnet.subnet-1-pub.id
  
}

resource "aws_subnet" "sri-private-subnet-1" {
  vpc_id = aws_vpc.sri_vpc.id
  availability_zone = "us-west-2a"
  cidr_block = var.pri_subnet_1_cidr
  tags = {
    Name=var.pri_subnet_1_name
  }

}


resource "aws_subnet" "sri-private-subnet-2" {
  vpc_id = aws_vpc.sri_vpc.id
  availability_zone = "us-west-2b"
  cidr_block = var.pri_subnet_2_cidr
  tags = {
    Name=var.pri_subnet_2_name
  }

}

resource "aws_nat_gateway" "sri-ngw" {
  vpc_id = aws_vpc.sri_vpc.id
  availability_mode = "regional"
  tags = {
    Name="sri-ngw"
  }
}

resource "aws_route_table" "sri-private-route" {
    vpc_id = aws_vpc.sri_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.sri-ngw.id
    }
  tags = {
    Name="sri-private-route-table"
  }
}

resource "aws_route_table_association" "sri-pvt-rt-assoc-1" {
  route_table_id = aws_route_table.sri-private-route.id
  subnet_id = aws_subnet.sri-private-subnet-1.id
}


resource "aws_route_table_association" "sri-pvt-rt-assoc-2" {
  route_table_id = aws_route_table.sri-private-route.id
  subnet_id = aws_subnet.sri-private-subnet-2.id
}

resource "aws_security_group" "sri-sg-1" {
  name = "sri-ec2-sg"
  vpc_id = aws_vpc.sri_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all traffic"
    protocol = "tcp"
  }
 
}

# resource "aws_instance" "sri-ec2" {
#     subnet_id = aws_subnet.subnet-1-pub.id
#     security_groups = [ aws_security_group.sri-sg-1.id ]
#     instance_type = var.ec2_type
#     ami = var.ec2_ami

#     tags = {
#       Name="sri-ec2"
#     }
# }

resource "aws_db_subnet_group" "sri-rds-subnetgroup" {
  name = "sri-rds-subnetgrp"
  subnet_ids = [ aws_subnet.sri-private-subnet-1.id,aws_subnet.sri-private-subnet-2.id ]
  description = "subnet group for sri rds instance"
  
}

resource "aws_db_instance" "sri-rds" {
 identifier = "sri-rds"
 engine = "mysql"
 engine_version = "8.0"
 instance_class = "db.t3.micro"
 vpc_security_group_ids = [ aws_security_group.sri-sg-1.id ]
 db_subnet_group_name = aws_db_subnet_group.sri-rds-subnetgroup.id
 publicly_accessible = false
 username = "admin"
 password = "Cloud123"
 storage_type = "gp2"
 allocated_storage = 20

}