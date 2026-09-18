terraform {
  backend "s3" {
    region       = "us-west-2"
    bucket       = "sri-state-file"
    key          = "sri-prod/terraform.tfstate"
    use_lockfile = true
  }
}