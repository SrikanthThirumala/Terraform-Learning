variable "ami" {
  default = ""
  description = "ami value for ec2"
  type = string
}

variable "ec2_type" {
  default = ""
  description = "instance type value for ec2"
  type = string
}

variable "ec2_sg" {
  default = ""
  description = "sg value for ec2"
  type = string
}

variable "ec2_subnet_id" {
  default = ""
  description = "subnet_id value for ec2"
  type = string
}

variable "ec2_name" {
  default = ""
  description = "name for ec2"
  type = string
}