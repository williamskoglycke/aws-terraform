output "terraform_access_key_id" {
  value = aws_iam_access_key.terraform_user_key.id
}

output "terraform_secret_access_key" {
  value     = aws_iam_access_key.terraform_user_key.secret
  sensitive = true
}