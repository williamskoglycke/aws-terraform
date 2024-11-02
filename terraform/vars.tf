variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS Region"
  type        = string
  default = "eu-north-1"
}

variable "container_repo_name" {
  description = "The name of the container repo."
  type        = string
  default = "my_container_repo"
}
