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

variable "repository_name" {
  description = "The name of the repository."
  default     = "aws-terraform"
}

variable "aws_role_to_assume" {
  description = "The ARN of the role to assume."
  type        = string
}

variable "aws_role_external_id" {
  description = "The external ID of the role to assume."
  type        = string
}