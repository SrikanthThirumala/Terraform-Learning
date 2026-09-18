module "sri_network" {
  source       = "./Network_Module"
  vpc_cidr     = "10.0.0.0/16"
  vpc_tag      = "sri-custom-vpc"
  subnet_1_cidr  = "10.0.1.0/24"
  subnet_2_cidr  = "10.0.2.0/24"
  pub_rt_cidr = "0.0.0.0/0"
  subnet_1_tag   = "sri-public-subnet-1"
  subnet_2_tag   = "sri-public-subnet-2"
  ec2_sec_name = "ec2-sg"
}

module "compute" {
  source = "./Compute_Module"
  ami = "ami-0413c9aa513b49c44"
  ec2_type = "t3.micro"
  ec2_name = "sri-ec2"
  ec2_sg = module.sri_network.sg
  ec2_subnet_id = module.sri_network.subnet-1
  

}

module "storage" {
  source = "./Storage_Module"
  rds_name = "sri-rds"
  rds_instance_class = "db.t3.micro"
  rds_allo_storage = 20
  rds_engine = "mysql"
  rds_engine_version = "8.0"
  rds_subnet_grp_name = "sri-rds-subnet-grp"
  rds_db_username = "admin"
  rds_storage_type = "gp2"
  rds_subnet_1 = module.sri_network.subnet-1
  rds_subnet_2 = module.sri_network.subnet-2
  rds_sg = module.sri_network.sg
}



