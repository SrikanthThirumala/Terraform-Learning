output "vpc_id" {
  description = "vpc id value"
  value = aws_vpc.sri-custom-vpc.id
}

output "sg" {
  description = "sg value"
  value = aws_security_group.sri-ec2-sg.id
}

output "subnet-1" {
  description = "subnet 1 value"
  value = aws_subnet.sri_public_subnet-1.id
}

output "subnet-2" {
  description = "subnet 2 value"
  value = aws_subnet.sri_public_subnet-2.id
}

