// Setting up providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

// Setting up AWS
provider "aws" {
  region  = var.aws_variables.region
}

// Generating a key pair to use for all ec2 instances
resource "tls_private_key" "terraformKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Creating a key pair on AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "TerraformKeyPair.pem"
  public_key = tls_private_key.terraformKey.public_key_openssh
}

// Creating a security group
resource "aws_security_group" "sg" {
  description = "Security group for terraform ec2 instance"
  vpc_id      = var.aws_variables.vpc_id
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      description = ingress.value["name"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

// Allocating an elastic ip
resource "aws_eip" "ec2-eip" {
  vpc      = true

  tags = {
    Name = "terraform-ec2-eip"
  }
}

// Creating the AWS instance
resource "aws_instance" "instance" {
  ami                         = var.ami_ids.ubuntu
  instance_type               = var.ec2.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = aws_key_pair.generated_key.id
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.ec2.volume_size
    volume_type           = var.ec2.volume_type
  }
  // Setting the environment variables of EC2 bootstrap script
  user_data = templatefile("script/${var.ec2.os_type}.sh", 
  {
    GIT_USERNAME = var.github_access_info.username,
    GIT_PAT = var.github_access_info.personal_access_token,
    GIT_ADDRESS = var.github_access_info.github_repo_address,
    FRONTEND_PORT = var.project_env.frontend.port,
    BACKEND_PORT = var.project_env.backend.port,
    IS_BACKEND_SECURE = var.project_env.backend.is_secure_connection,
    IS_FRONTEND_SECURE = var.project_env.frontend.is_secure_connection,
    SERVER_IP_ADDRESS = aws_eip.ec2-eip.public_ip,
    JENKINS_GUI_PORT = var.project_env.jenkins.gui_port,
    JENKINS_SSH_PORT = var.project_env.jenkins.ssh_port,
    JENKINS_USER_ID = var.project_env.jenkins.user_id,
    JENKINS_USER_PW = var.project_env.jenkins.user_pw,
    KEY_PAIR_CONTENT = tls_private_key.terraformKey.private_key_pem
  })

  user_data_replace_on_change = true

  tags = {
    Name = var.ec2.name
  }
}

// Associate the elastic ip
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.ec2-eip.allocation_id
}

// Generated Key's file
resource "local_file" "private_key" {
    content  = tls_private_key.terraformKey.private_key_pem
    filename = "TerraformKeyPair.pem"
}

// Outputting some values to console
output "output" {
  value = {
    region = var.aws_variables.region
    ec2_public_ip = aws_eip.ec2-eip.public_ip
    key_pair = "key pair is saved as private_key.pem"
    ports = [
      for rule in var.security_groups : format("%s: %s",rule.name, rule.from_port)
    ]
    jenkins_credentials = {
      user_id = var.project_env.jenkins.user_id
      user_pw = var.project_env.jenkins.user_pw
    }
  }
}