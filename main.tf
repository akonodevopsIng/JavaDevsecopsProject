terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

# Groupe de sécurité : autorise tout le trafic entrant/sortant
resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Utilise la dernière AMI Ubuntu 22.04 LTS officielle dans us-east-1
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Récupère le VPC par défaut (pour le groupe de sécurité)
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  key_name      = "MyNewKeyPair"

  # Utilise l'ID du groupe de sécurité !
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "MyUbuntuInstance"
  }
}
