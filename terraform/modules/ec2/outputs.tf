output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_security_group.id
}

output "public_ip" {
  value = aws_instance.server.public_ip
}

output "private_key_path" {
  value = local_file.private_key.filename
}

output "instance_id" {
  value = aws_instance.server.id
}