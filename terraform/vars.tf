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
  default     = "eu-north-1"
}

variable "backend_container_name" {
  description = "The name of the backend container."
  type        = string
  default     = "backend"
}

variable "frontend_container_name" {
  description = "The name of the frontend container."
  type        = string
  default     = "frontend"
}

variable "github_action_user_name" {
  description = "GitHub action user name"
  type        = string
  default     = "deployer"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "williamskoglyckebucket"
}

