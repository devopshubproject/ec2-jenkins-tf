terraform {
  backend "s3" {
    key            = "global/region/ap-south-1/dev/devops-poc.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}