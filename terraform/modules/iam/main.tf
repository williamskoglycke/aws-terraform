provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

resource "aws_iam_policy" "terraform_access_policy" {
  name        = "Terraform_Access_Policy"
  description = "Policy to allow Terraform access for basic operations"
  policy      = jsonencode({
    Version = "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*",
          "ecr:*",
          "iam:*",
          "rds:*",
          "s3:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "terraform_group_policy" {
    user       = aws_iam_user.terraform_user.name
    policy_arn = aws_iam_policy.terraform_access_policy.arn
}

resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.terraform_user.name
}



