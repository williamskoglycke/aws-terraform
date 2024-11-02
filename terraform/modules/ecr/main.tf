provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

resource "aws_ecr_repository" "backend_repo" {
  name = var.backend_container_name
}

resource "aws_ecr_repository" "frontend_repo" {
  name = var.frontend_container_name
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecr.amazonaws.com",
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.github_action_user_name}"
        },
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "assume_ecr_role_policy" {
  name        = "AssumeECRRolePolicy"
  description = "Policy to allow assuming the ECR role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        Resource = aws_iam_role.ecr_role.arn
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRPolicy"
  description = "Policy to allow access to ECR"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ssm:SendCommand",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_role_policy_attachment" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_user_policy_attachment" "ecr_user_assume_role_attachment" {
  user       = var.github_action_user_name
  policy_arn = aws_iam_policy.assume_ecr_role_policy.arn
}

resource "aws_iam_access_key" "ecr_user_key" {
  user = var.github_action_user_name
}