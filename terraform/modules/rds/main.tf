provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "db-subnet-group"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Allow RDS access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_db_instance" "server_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t4g.micro"
  username             = "postgres"
  password             = var.db_password
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  tags = {
    Name = "server_db"
  }
}

resource "aws_iam_policy" "rds_access_policy" {
  name        = "RDSAccessPolicy"
  description = "Policy to allow access to RDS"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "rds:DescribeDBInstances",
        "rds:Connect"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
  count      = length(var.role_names)
  role       = var.role_names[count.index]
  policy_arn = aws_iam_policy.rds_access_policy.arn
}