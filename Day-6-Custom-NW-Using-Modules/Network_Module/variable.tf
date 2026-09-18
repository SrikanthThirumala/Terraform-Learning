variable "vpc_cidr" {
  default     = ""
  type        = string
  description = "Cidr value for VPC"
}

variable "vpc_tag" {
  default     = ""
  description = "vpc name value"
  type        = string
}

variable "pub_rt_name" {
  default     = ""
  description = "Public rt table name value"
  type        = string
}

variable "igw_name" {
  default     = ""
  description = "IGW name value"
  type        = string
}

variable "pub_rt_cidr" {
  default     = ""
  description = "public rt table cidr value"
  type        = string
}
variable "subnet_1_cidr" {
  default     = ""
  type        = string
  description = "subnet 1 cidr value"
}

variable "subnet_1_tag" {
  default     = ""
  description = "subnet  1 name value"
  type        = string
}


variable "subnet_2_cidr" {
  default     = ""
  type        = string
  description = "subnet 2  cidr value"
}

variable "subnet_2_tag" {
  default     = ""
  description = "subnet 2 name value"
  type        = string
}


variable "ec2_sec_name" {
  default     = ""
  description = "value for ec2 security group"
  type        = string
}


