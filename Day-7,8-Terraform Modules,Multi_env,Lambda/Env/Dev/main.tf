module "sri_network" {
  source       = "../../modules/Network_Module"
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
  source = "../../modules/Compute_Module"
  ami = "ami-0413c9aa513b49c44"
  ec2_type = "t3.micro"
  ec2_name = "sri-ec2"
  ec2_sg = module.sri_network.sg
  ec2_subnet_id = module.sri_network.subnet-1
  

}

module "lambda" {
  source = "../../modules/Lambda_Module"
}


