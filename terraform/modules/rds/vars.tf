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

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "security_groups" {
    description = "A list of security groups to associate with the RDS instance"
    type        = list(string)
}

variable "role_names" {
  description = "A list of IAM role names to associate with the RDS instance"
  type        = list(string)
}
