terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-017fecd1353bcc96e"
  instance_type          = "t2.micro"
  key_name               = "Teraform-key"
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = file("./docker.sh")

  tags = {
    Name = "Core_instance"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      name             = "SSH main getway"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      from_port        = 80
      name             = "NGINX Port HTTP"
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      protocol         = "tcp"
      to_port          = 80
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      from_port        = 443
      name             = "NGINX Port HTTPS"
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      protocol         = "tcp"
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]
}