module "iam" {
  source                  = "./modules/iam"
  region                  = var.region
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  github_action_user_name = var.github_action_user_name
}

module "ec2" {
  source                  = "./modules/ec2"
  region                  = var.region
  aws_access_key          = module.iam.terraform_access_key_id
  aws_secret_key          = module.iam.terraform_secret_access_key
  backend_container_name  = var.backend_container_name
  frontend_container_name = var.frontend_container_name
}

module "s3" {
  source         = "./modules/s3"
  region         = var.region
  aws_access_key = module.iam.terraform_access_key_id
  aws_secret_key = module.iam.terraform_secret_access_key
  bucket_name    = "williamskoglyckebucket"
  role_names = [module.ec2.ec2_role_name]
}

module "rds" {
  source         = "./modules/rds"
  region         = var.region
  db_password    = var.db_password
  aws_access_key = module.iam.terraform_access_key_id
  aws_secret_key = module.iam.terraform_secret_access_key
  security_groups = [module.ec2.ec2_security_group_id]
  role_names = [module.ec2.ec2_role_name]
}

module "ecr" {
  source                  = "./modules/ecr"
  region                  = var.region
  aws_access_key          = module.iam.terraform_access_key_id
  aws_secret_key          = module.iam.terraform_secret_access_key
  backend_container_name  = var.backend_container_name
  frontend_container_name = var.frontend_container_name
  github_action_user_name = var.github_action_user_name
}

module "github" {
  source                  = "./modules/github"
  github_token            = var.github_token
  aws_role_to_assume      = module.ecr.role_to_assume
  aws_role_external_id    = module.ecr.role_external_id
  aws_access_key          = module.ecr.container_uploader_access_key_id
  aws_secret_key          = module.ecr.container_uploader_secret_access_key
  backend_container_name  = var.backend_container_name
  frontend_container_name = var.frontend_container_name
  ec2_instance_id         = module.ec2.instance_id
}
