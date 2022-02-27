# General

environment = "dev"
region = "ap-south-1"

# Network
# net_name = "stage-mumbai-1"
# vpc_cidr = "172.16.0.0/16"
# pvt_subnet_cidr = "172.16.1.0/24"

vpc_id = "vpc-04e2717510b8b8371"
subnet_id = "subnet-0f8f06dc9caf93dc2"

# EC2

#ami_id = """
instance_type = "t2.medium"
burstable_mode = "standard"
monitoring = false
instance_initiated_shutdown_behavior = "stop"
root_volume_type = "standard"
root_volume_size = 50
root_iops = "gp3"
root_block_device_encrypted = false
disable_api_termination = false
src_dest_check = false
delete_on_termination = true
metadata_http_tokens_required = "optional"
metadata_http_endpoint_enabled = "enabled"
metadata_http_put_response_hop_limit = 1
username = "wcar_op"


# EBS

ebs_optimized = true
ebs_device_name = "/dev/sdf"
ebs_az_zone = "ap-south-1a"
ebs_volume_encrypted = "false"
ebs_volume_type = "standard"
ebs_volume_size = 100
ebs_iops = "gp3"
rotation_enabled = false