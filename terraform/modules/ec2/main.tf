provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_security_group" {
  name = "server"

  ingress {
    from_port	  = var.server_port
    to_port	      = var.server_port
    protocol	  = "tcp"
    cidr_blocks	  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_security_group"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.tls.private_key_pem
  filename = "${path.module}/my-key.pem"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = tls_private_key.tls.public_key_openssh
}



resource "aws_instance" "server" {
  ami			          = "ami-02db68a01488594c5"
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.ssh_key.key_name
  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids  = ["${aws_security_group.ec2_security_group.id}", "${aws_security_group.allow_ssh.id}"]

  user_data = <<-EOF
              #!/bin/bash
              # Install Docker
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "DockerInstance"
  }
}