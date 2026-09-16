terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "sri-terraform-statefile"
    key ="Day-4-Migrating-Terraform-State-to-S3-and-Deploying-a-Private-RDS-Instance/terraform.tfstate"
  }
}