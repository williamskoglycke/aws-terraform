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

variable "domain_name" {
  description = "The domain name for the application."
}