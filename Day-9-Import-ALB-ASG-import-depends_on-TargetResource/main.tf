resource "aws_vpc" "sri_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="Sri-VPC"
  }
}

resource "aws_internet_gateway" "sri_igw" {
  vpc_id = aws_vpc.sri_vpc.id
  tags = {
    Name="sri_igw"
  }
}


resource "aws_subnet" "sri-public-subnet-1" {
  vpc_id = aws_vpc.sri_vpc.id
  availability_zone = "us-west-2a"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="sri-public-subnet-1"
  }
}


resource "aws_subnet" "sri-public-subnet-2" {
  vpc_id = aws_vpc.sri_vpc.id
  availability_zone = "us-west-2b"
  cidr_block = "10.0.2.0/24"
  tags = {
    Name="sri-public-subnet-2"
  }
}

resource "aws_route_table" "sri_public_route_table" {
  vpc_id = aws_vpc.sri_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sri_igw.id
  }
  tags = {
    Name="sri-public-rt-table"
  }
}

resource "aws_route_table_association" "sri-public-rtb-assoc-1" {
  route_table_id = aws_route_table.sri_public_route_table.id
  subnet_id = aws_subnet.sri-public-subnet-1.id
}

resource "aws_route_table_association" "sri-public-rtb-assoc-2" {
  route_table_id = aws_route_table.sri_public_route_table.id
  subnet_id = aws_subnet.sri-public-subnet-2.id
}

resource "aws_security_group" "sri-sg" {
  vpc_id = aws_vpc.sri_vpc.id
  name = "sri-sg"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all traffic"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all traffic"
  }
}

resource "aws_instance" "sri-ec2-terraform" {
    
    ami = "ami-0413c9aa513b49c44"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.sri-sg.id ]
    availability_zone = "us-west-2a"
    subnet_id = aws_subnet.sri-public-subnet-1.id
    tags = {
      Name="sr-ec2"
    }
  
}

resource "aws_alb" "sri-alb" {
  name = "sri-alb"
  subnets = [ aws_subnet.sri-public-subnet-1.id,aws_subnet.sri-public-subnet-2.id ]
  security_groups = [ aws_security_group.sri-sg.id ]
  load_balancer_type = "application"
  tags = {
    Name="sri-alb"
  }
  depends_on = [ aws_instance.sri-ec2-terraform ]
}

resource "aws_alb_target_group" "sri-tg-1" {
  name = "sri-tg-1"
  vpc_id = aws_vpc.sri_vpc.id
  port = "80"
  protocol = "HTTP"

  health_check {
    port ="traffic-port"
    path="/"   
  }
    depends_on = [ aws_instance.sri-ec2-terraform ]
}

resource "aws_alb_target_group_attachment" "alb-tg-attach" {
  target_group_arn = aws_alb_target_group.sri-tg-1.arn
  target_id = aws_instance.sri-ec2-terraform.id
  port = "80"
  
}

resource "aws_alb_listener" "sri-alb-listener" {
  load_balancer_arn = aws_alb.sri-alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.sri-tg-1.arn
    type = "forward"
  }
    depends_on = [ aws_alb_target_group.sri-tg-1]
}


resource "aws_launch_template" "sri-lt-1" {
  name_prefix = "sri-lt"
  instance_type = "t3.micro"
  image_id = "ami-0413c9aa513b49c44"
  vpc_security_group_ids= [ aws_security_group.sri-sg.id ]
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              echo "Hello from ASG Instance" > /usr/share/nginx/html/index.html
              EOF
  )
    depends_on = [ aws_instance.sri-ec2-terraform ]
    tags = {
      Name="sri-lt-1"
    }

}

resource "aws_autoscaling_group" "sri-asg" {
    vpc_zone_identifier = [ aws_subnet.sri-public-subnet-1.id,aws_subnet.sri-public-subnet-2.id]
     target_group_arns = [ aws_alb_target_group.sri-tg-1.arn ]
    desired_capacity =2 
    max_size = 3
    min_size = 1
  launch_template {
    id = aws_launch_template.sri-lt-1.id
    version = "1"
  }
  health_check_grace_period = 300
  health_check_type = "ELB"
  depends_on = [ aws_launch_template.sri-lt-1 ]
  name = "sri-asg-1"

}


#terraform inport aws_instance.sri-manual-ec2 i-04545454545454545
resource "aws_instance" "sri-manual-ec2" {
    ami = "ami-075d448db8fb256af"
    subnet_id = aws_subnet.sri-public-subnet-2.id
    vpc_security_group_ids = [ aws_security_group.sri-sg.id ]
    availability_zone = "us-west-2b"
    instance_type = "t3.micro"
    tags = {
      Name="sri-manual-ec2"
    }
}