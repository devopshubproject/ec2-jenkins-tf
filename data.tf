data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

##################################################
# VPC Data Ref
##################################################

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

##################################################
# Subnet Data Ref
##################################################

data "aws_subnet" "pvt-subnet" {
  id = var.subnet_id
}