variable "vpc_cidr" {
  default = ""
  type = string
  description = "vpc cidr "
}

variable "vpc_name" {
  default = ""
  type = string
  description = "vpc name "
}

variable "pub_subnet_cidr" {
  default = ""
  type = string
  description = "public subnet cidr"
}

variable "pub_subnet_name" {
  default = ""
  type = string
  description = "public subnet name "
}


variable "pri_subnet_1_cidr" {
  default = ""
  type = string
  description = "private subnet-1 cidr"
}


variable "pri_subnet_2_cidr" {
  default = ""
  type = string
  description = "private subnet-2 cidr"
}

variable "pri_subnet_1_name" {
  default = ""
  type = string
  description = "private subnet 1 name "
}


variable "pri_subnet_2_name" {
  default = ""
  type = string
  description = "private subnet 2 name "
}
variable "igw_name" {
  default = ""
  type = string
  description = "IGW name "
}

variable "ec2_ami" {
  type = string
  default = ""
  description = "ami value for ec2"
}

variable "ec2_type" {
  type = string
  default = ""
  description = "value for ec2 instance type"
}

