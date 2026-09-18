resource "aws_db_instance" "sri-rds" {
  identifier = var.rds_name
  engine = var.rds_engine
  engine_version = var.rds_engine_version
  allocated_storage = var.rds_allo_storage
  db_subnet_group_name = aws_db_subnet_group.sri_rds_subnet_grp.id
  storage_type = var.rds_storage_type
  instance_class = var.rds_instance_class
  username =var.rds_db_username
  manage_master_user_password = true
  vpc_security_group_ids = [ var.rds_sg ]
  
  
}

resource "aws_db_subnet_group" "sri_rds_subnet_grp" {
  subnet_ids = [ var.rds_subnet_1,var.rds_subnet_2 ]
  name = "rds-subnet-grp"
  tags = {
    Name=var.rds_subnet_grp_name
  }
}