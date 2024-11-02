output "container_uploader_access_key_id" {
  value = aws_iam_access_key.ecr_user_key.id
}

output "container_uploader_secret_access_key" {
  value     = aws_iam_access_key.ecr_user_key.secret
  sensitive = true
}

output "role_to_assume" {
  value = aws_iam_role.ecr_role.arn
}

output "role_external_id" {
  value = aws_iam_role.ecr_role.unique_id
}