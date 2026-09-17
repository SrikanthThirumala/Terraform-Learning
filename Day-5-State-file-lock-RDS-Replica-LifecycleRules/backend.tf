terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "sri-terraform-statefile"
    key ="Sri-prod/terraform.tfstate"
    use_lockfile = true
    # dynamodb_table = "terraform-statefile-locking" 
   
  }
}