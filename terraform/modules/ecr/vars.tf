variable "region" {
  description = "AWS Region"
  type        = string
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

variable "backend_container_name" {
  description = "The backend container name."
  default = "backend"
}

variable "frontend_container_name" {
  description = "The frontend container name."
  default = "frontend"
}

variable "github_action_user_name" {
  description = "GitHub action user name"
  type        = string
}