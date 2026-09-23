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

resource "aws_key_pair" "ec2-keypair" {
  key_name = "ec2-keypair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "sri-ec2-terraform" {
    associate_public_ip_address = true
    ami = "ami-0413c9aa513b49c44"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.sri-sg.id ]
    availability_zone = "us-west-2a"
    subnet_id = aws_subnet.sri-public-subnet-1.id
    key_name = aws_key_pair.ec2-keypair.key_name
    tags = {
      Name="sr-ec2"
    }
  
}


resource "null_resource" "file-provis" {
    connection {
      host = aws_instance.sri-ec2-terraform.public_ip
      type = "ssh"
      private_key = file("~/.ssh/id_ed25519")
      timeout = "2m"
      user = "ec2-user"
      }

    provisioner "file" {
      
      source = "backendscript.sh"
      destination = "/home/ec2-user/backendscript.sh"
    }
}


resource "null_resource" "remote-exe" {
  depends_on = [ null_resource.file-provis ,aws_instance.sri-ec2-terraform,aws_security_group.sri-sg]
  connection {
      host = aws_instance.sri-ec2-terraform.public_ip
      type = "ssh"
      private_key = file("~/.ssh/id_ed25519")
      timeout = "2m"
      user = "ec2-user"
      }
    provisioner "remote-exec" {
      inline = [ 
        "chmod +x /home/ec2-user/backendscript.sh",
      "sudo /home/ec2-user/backendscript.sh"
       ]
    }
    triggers = {
        script_hash=filemd5("backendscript.sh")
    }
}


output "sri_ec2_public_ip" {
  value = aws_instance.sri-ec2-terraform.public_ip
}
