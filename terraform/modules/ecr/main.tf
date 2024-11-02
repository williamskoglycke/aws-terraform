provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

resource "aws_ecr_repository" "container_repo" {
  name = var.container_repo_name
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecr.amazonaws.com"
        },
        Action = "sts:AssumeRole"
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
        Action = "sts:AssumeRole",
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
          "ecr:UploadLayerPart"
        ],
        Resource = aws_ecr_repository.container_repo.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_role_policy_attachment" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_user" "ecr_user" {
  name = "ecr_user"
}

resource "aws_iam_user_policy_attachment" "ecr_user_assume_role_attachment" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = aws_iam_policy.assume_ecr_role_policy.arn
}

resource "aws_iam_access_key" "ecr_user_key" {
  user = aws_iam_user.ecr_user.name
}