variable "rds_name" {
  default = ""
  description = "rds identifier value"
  type = string
}



variable "rds_engine" {
  default = ""
  description = "rds engine value"
  type = string
}


variable "rds_engine_version" {
  default = ""
  description = "rds engine  version value"
  type = string
}

variable "rds_allo_storage" {
  
  description = "rds engine  version value"
  type = number
}

variable "rds_subnet_1" {
  default = ""
  description = "subnet 1  value for subnet group"
  type = string
}


variable "rds_subnet_2" {
  default = ""
  description = "subnet 2  value for subnet group"
  type = string
}

variable "rds_db_username" {
  default = ""
  description = "db username value for RDS"
  type = string
}

variable "rds_sg" {
  default = ""
  description = "sg value for RDS"
  type = string
}
variable "rds_subnet_grp_name" {
  default = ""
  description = "rds subnet group name value"
  type = string
}

variable "rds_storage_type" {
  default = ""
  description = "rds storage type value"
  type = string
}

variable "rds_instance_class" {
  default = ""
  description = "rds instance class value"
  type = string
}
