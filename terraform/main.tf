 provider "aws" {
    region = var.aws_region
  }

  # Generate SSH key pair
  resource "tls_private_key" "strapi_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }

  resource "aws_key_pair" "strapi_key" {
    key_name   = var.key_name
    public_key = tls_private_key.strapi_key.public_key_openssh
  }

  # Save private key locally
  resource "local_file" "private_key_pem" {
    content         = tls_private_key.strapi_key.private_key_pem
    filename        = var.private_key_path
    file_permission = "0400"
  }

  # Optional: Get default VPC (required for security group if you don't provide your own VPC)
  data "aws_vpc" "default" {
    default = true
  }

  # Security Group with valid block structure
  resource "aws_security_group" "strapi_sg" {
    name        = "strapi-sg"
    description = "Allow SSH and HTTP"
    vpc_id      = data.aws_vpc.default.id

    ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }

    ingress {
      description      = "Strapi Admin"
      from_port        = 1337
      to_port          = 1337
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }

    egress {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }

    tags = {
      Name = "Strapi SG"
    }
  }

  # EC2 instance with provisioners
  resource "aws_instance" "strapi_ec2" {
    ami                    = "ami-0f918f7e67a3323f0" # Ubuntu 22.04 LTS (us-east-1)
    instance_type          = var.instance_type
    key_name               = aws_key_pair.strapi_key.key_name
    vpc_security_group_ids = [aws_security_group.strapi_sg.id]

    provisioner "file" {
      source      = "script.sh"
      destination = "/home/ubuntu/script.sh"

      connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = tls_private_key.strapi_key.private_key_pem
        host        = self.public_ip
      }
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /home/ubuntu/script.sh",
        "sudo /home/ubuntu/script.sh"
      ]

      connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = tls_private_key.strapi_key.private_key_pem
        host        = self.public_ip
      }
    }

    tags = {
      Name = "StrapiApp"
    }
  }
