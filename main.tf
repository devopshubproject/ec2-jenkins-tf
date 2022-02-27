##################################################
# Security Group
##################################################

resource "aws_security_group" "sg" {
  name        = "${var.environment}-${var.app_name}-sg"
  description = "jumphost security group"
  vpc_id      = data.aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${local.common_tags}"
}

##################################################
# Security Group - Ingress rule
##################################################

resource "aws_security_group_rule" "ingress" {
  count   = length(var.sg_from_ingress_rule) == length(var.sg_to_ingress_rule) ? length(var.sg_from_ingress_rule) : 0
  type              = "ingress"
  from_port         = element(var.sg_from_ingress_rule, count.index)
  to_port           = element(var.sg_to_ingress_rule, count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description = "http default port"
}

/* ##################################################
# Security Group - Egress rule
##################################################

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = aws_security_group.sg.id
  description = "ml application port"
} */

##################################################
# EBS Volume
##################################################

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.ebs_az_zone
  size              = var.ebs_volume_size
  #iops              = var.ebs_iops
  type              = var.ebs_volume_type
  encrypted         = var.ebs_volume_encrypted
  #kms_key_id        = aws_kms_key.kms_key.key_id
  tags = "${local.common_tags}"
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.vm.id
}


##################################################
# SSH Key
##################################################

resource "tls_private_key" "sshkey" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "private_key" {
    content = tls_private_key.sshkey.private_key_pem
    filename = "key.pem"
    file_permission = "0600"
}
resource "aws_key_pair" "ssh_pvt_key" {
    key_name = "${var.environment}-${var.app_name}-ssh-key"
    public_key = tls_private_key.sshkey.public_key_openssh
    tags = "${local.common_tags}"  
}

##################################################
# Random Password
##################################################

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

##################################################
# EIP Creation
##################################################

resource "aws_eip" "eip" {
  public_ipv4_pool = "amazon"
  vpc              = true
  tags = "${local.common_tags}"
  timeouts {}
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.vm.id
  allocation_id = aws_eip.eip.id
}


##################################################
# VM Creation
##################################################

resource "aws_instance" "vm" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type                        = var.instance_type
  subnet_id                            = data.aws_subnet.pvt-subnet.id
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  key_name                             = aws_key_pair.ssh_pvt_key.key_name
  monitoring                           = var.monitoring
  source_dest_check                    = var.src_dest_check
  vpc_security_group_ids               = [aws_security_group.sg.id]

  # tags {
  #   Name = "${var.environment}-${var.app_name}-vm"
  # }

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    #iops                  = var.root_iops
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
  }

  connection {
    type     = "ssh"
    user     = var.username
    password = random_password.password.result
    host     = self.public_ip
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required
  }

  credit_specification {
    cpu_credits = var.burstable_mode
  }

  tags = "${local.common_tags}"

  volume_tags = "${local.common_tags}"

 provisioner "remote-exec"  {
    inline  = [
      "sudo yum update -y",
      "sudo yum install -y jenkins java-11-openjdk-devel",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade -y",
      "sudo yum install jenkins -y",
      "sudo systemctl start jenkins",
      "sudo amazon-linux-extras install ansible2 -y"
      ]
   }

}