resource "aws_instance" "sri-ec2" {

    ami = var.ami
    instance_type = var.ec2_type
    vpc_security_group_ids = [ var.ec2_sg ]
    subnet_id = var.ec2_subnet_id

    tags = {
      Name=var.ec2_name
    }


  
}