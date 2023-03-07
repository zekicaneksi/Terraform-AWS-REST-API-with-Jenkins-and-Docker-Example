variable "aws_variables" {
  description = "AWS variables"
  type = object({
    region = string
    vpc_id = string
  })
}

variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ami_ids" {
  type = object({
    ubuntu = string
  })
}

variable "ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
  })
}

variable "github_access_info" {
    type = object({
        username = string
        personal_access_token = string
        github_repo_address = string
    })
}

variable project_env {
    type = object({
        frontend = object ({
            port = string
            is_secure_connection = bool
        })
        backend = object ({
            port = string
            is_secure_connection = bool
        })
        jenkins = object ({
          gui_port = string
          ssh_port = string
          user_id = string
          user_pw = string
        })
    })
}