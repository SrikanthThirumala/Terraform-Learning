variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "cidr value for vpc"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
  description = "cidr range for subnet-1"
}

variable "vpc_tag" {
  type = string
  default = "dev_vpc"
}

variable "subnet_tag" {
  type = string
  default = "dev_subnet"
}