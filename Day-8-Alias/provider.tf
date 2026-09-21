provider "aws" {
  profile = "dev_profile"
  alias = "west-2-region"

}

provider "aws" {
  profile = "test_profile"
  alias = "east-1-region"
  
}

