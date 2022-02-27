##### Global Variable #####

#### Tags ####
variable "owner" {
  type        = string
  description = "The name of the infra provisioner or owner"
  default     = "Prem"
}
variable "environment" {
  type        = string
  description = "The environment name"
}
variable "cost_center" {
  type        = string
  description = "The cost_center name for this project"
  default     = "infra"
}
variable "app_name" {
  type        = string
  description = "Application name of project"
  default     = "jenkins"
}

variable "region" {
  description = "The AWS region"
  type        = string
}

# variable "aws_profile" {
#   description = "The name of the AWS shared credentials account."
#   type        = string
# }


### Network ###
# variable "net_name" {
#   type        = string
#   description = "The development network environment vpc name"
# }

# variable "vpc_cidr" {
#   type = string
# }

# variable "pvt_subnet_cidr" {
#   type = string
# }

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

### Security ###

variable "sg_from_ingress_rule" {
  type = list(any)
  default = [22, 443, 8080]
}

variable "sg_to_ingress_rule" {
  type = list(any)
  default = [22, 443, 8080]
}

### Volume ###

variable "ebs_az_zone" {
  description = "The AZ where the EBS volume will exist"
  type = string
}

variable "ebs_volume_size" {
  description = "The size of the drive in GiBs"
  type = number
}

variable "ebs_iops" {
  description = "The amount of IOPS to provision for the disk"
  type = string
}

variable "ebs_volume_type" {
  description = "The type of EBS volume"
  type = string
}

variable "ebs_device_name" {
  description = "The Name of EBS volume"
  type = string
}

variable "ebs_volume_encrypted" {
  description = "Do you want the disk to be encrypted, true or false"
  type = string
}

### Instance ###

# variable "vm_name" {
#   description = "Specific the name of the vm"
#   type = string
# }

variable "ami_id" {
  description = "The AMI (Amazon Machine Image) that identifies the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to be used"
  type        = string
}

variable "ebs_optimized" {
  description = "Do you want the EC2 instance backed by EBS to be EBS-optimized, true or false"
  type        = string
}

variable "disable_api_termination" {
  description = "Want to prevent your instance from being accidentally terminated, true or false"
  type        = string
}

variable "instance_initiated_shutdown_behavior" {
  description = "Specific Shutdown behavior for the instance"
  type        = string
}

variable "monitoring" {
  description = "Do you want detailed monitoring enabled, true or false"
  type        = string
}

variable "src_dest_check" {
  description = "want to Controls if traffic is routed to the instance when the destination address does not match the instance true or false"
  type        = string
}

variable "root_volume_type" {
  description = "Specific the root volume type"
  type        = string
}
variable "root_volume_size" {
  description = "Specific the root volume size in GB"
  type        = string
}

variable "root_iops" {
  description = "Specific the amount of IOPS needed for root volume"
  type        = string
}

variable "delete_on_termination" {
  description = "Want the volume to be destroyed on instance termination, true or false"
  type        = string
}
variable "root_block_device_encrypted" {
  description = "Do you want to enable root volume encryption, true or flase "
  type        = string
}

variable "metadata_http_endpoint_enabled" {
  description = "Do you want the metadata service, enabled or disabled"
  type        = string
}

variable "metadata_http_put_response_hop_limit" {
  description = "Desired HTTP PUT response hop limit for instance metadata requests, 1 to 64"
  type        = string
}

variable "metadata_http_tokens_required" {
  description = "Do you Whether or not the metadata service requires session tokens, optional or required"
  type        = string
}

variable "burstable_mode" {
  description = "Specific the Credit option for CPU usage, standard or unlimited"
  type        = string
}

variable "user_arn" {
  description = "Specific the user details"
  default = "data.aws_caller_identity.current.account_id:user/prem.kumar"
}

variable "key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports"
  default = "SYMMETRIC_DEFAULT"
}

variable "enabled" {
  description = "Specifies whether the key is enabled"
  default = true
}

variable "rotation_enabled" {
  description = "Specifies whether key rotation is enabled, true or false"
  type = string
}

variable "username" {
  description = "Specifies Root User name"
  type = string
}