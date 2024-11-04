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

resource "aws_ssm_document" "deploy_backend_command" {
  name          = "DeployBackend"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2",
    description   = "Deploy backend",
    parameters = {
      ImageTag = {
        type = "String"
        description = "The Docker image tag"
      }
    },
    mainSteps = [{
      action = "aws:runShellScript",
      name   = "deployBackend",
      inputs = {
        runCommand = [
          "docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.backend_container_name}:{{ ImageTag }}",
          "docker rm $(docker stop $(docker ps -a -q --filter=\"name=${var.backend_container_name}\"))",
          "docker run -d --network my_network --name ${var.backend_container_name} ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.backend_container_name}:{{ ImageTag }}"
        ]
      }
    }]
  })
}

resource "aws_ssm_association" "deploy_backend_association" {
  name       = aws_ssm_document.deploy_backend_command.name
  targets {
    key    = "InstanceIds"
    values = [aws_instance.server.id]
  }
  parameters = {
    ImageTag = "latest"  # Replace "latest" with the actual tag you want to use
  }
}

resource "aws_iam_policy" "ecr_role_policy" {
  name        = "ECRBasicOperationsRolePolicy"
  description = "Policy to allow assuming the ECR role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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

data "aws_caller_identity" "current" {}

resource "aws_instance" "server" {
  ami			          = "ami-02db68a01488594c5"
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.ssh_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids  = [aws_security_group.ec2_security_group.id, aws_security_group.allow_ssh.id]

  user_data = <<-EOF
              #!/bin/bash
              # Install Docker
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
              sudo docker network create my_network
              EOF

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ec2-user/nginx",
      "sudo chown ec2-user:ec2-user /home/ec2-user/nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.private_key.filename)
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "./modules/ec2/files/nginx.conf"
    destination = "/home/ec2-user/nginx/nginx.conf"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.private_key.filename)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run -p 80:80 -d --network my_network -v ./nginx/nginx.conf:/etc/nginx/nginx.conf nginx:latest"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.private_key.filename)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "DockerInstance"
  }
}