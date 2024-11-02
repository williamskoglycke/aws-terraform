provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

resource "aws_s3_bucket" "server_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow access to S3"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  count      = length(var.role_names)
  role       = var.role_names[count.index]
  policy_arn = aws_iam_policy.s3_access_policy.arn
}