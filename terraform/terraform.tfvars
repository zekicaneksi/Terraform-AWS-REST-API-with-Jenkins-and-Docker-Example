aws_variables = {
  region = "eu-central-1" // the region where the ec2 instance will be created
  vpc_id = "vpc-01234567abc" // will be used when creating security group
}

/*
  Will be used for GitHub access from the EC2 instance, and from Docker containers.
  PAT Must have the private repo scope if repo is private.
*/
github_access_info = {
    username = "zekicaneksi"
    personal_access_token = "asavsagaegawojawfasfasf"
    github_repo_address = "/zekicaneksi/Terraform-AWS-REST-API-with-Jenkins-and-Docker-Example"
}

/*
  Environment variables for projects that will be consumed by Docker containers.
  Important: "security_groups" variable's rules must be considered when arranging the ports
*/
project_env = {
    frontend = {
        port = "80"
        is_secure_connection = false
    }
    backend = {
        port = "3000" // Must be the same with security group API port
        is_secure_connection = false
    }
    jenkins = {
      gui_port = "8080"
      ssh_port = "50000"
      user_id = "admin-chef-jenkins"
      user_pw = "butler"
    }
}

// Note: Amazon Machine Image (AMI) changes depending on region
ami_ids = {
  ubuntu = "ami-0d1ddd83282187d18"
}

ec2 = {
  instance_type     = "t2.small"
  name              = "instance-name"
  os_type           = "ubuntu"
  volume_size       = 16
  volume_type       = "gp2"
}

// Security group inbound rules
security_groups = [{
  from_port   = 22
  name        = "SSH Connections"
  protocol    = "tcp"
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
  }, {
  from_port   = 80
  name        = "HTTP Port"
  protocol    = "tcp"
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}, {
  from_port   = 443
  name        = "HTTPS Port"
  protocol    = "tcp"
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
}, {
  from_port   = 3000
  name        = "Backend API Port"
  protocol    = "tcp"
  to_port     = 3000
  cidr_blocks = ["0.0.0.0/0"]
}, {
  from_port   = 8080
  name        = "Jenkins GUI Port"
  protocol    = "tcp"
  to_port     = 8080
  cidr_blocks = ["0.0.0.0/0"]
}, {
  from_port   = 50000
  name        = "Jenkins SSH Port"
  protocol    = "tcp"
  to_port     = 50000
  cidr_blocks = ["0.0.0.0/0"]
}]