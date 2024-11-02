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

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "role_names" {
  description = "A list of IAM role names to associate with the RDS instance"
  type        = list(string)
}