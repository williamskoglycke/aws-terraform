output "container_uploader_access_key_id" {
  value = module.ecr.container_uploader_access_key_id
}

output "container_uploader_secret_access_key" {
  value     = module.ecr.container_uploader_secret_access_key
  sensitive = true
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "rds_address" {
  value = module.rds.rds_endpoint
}