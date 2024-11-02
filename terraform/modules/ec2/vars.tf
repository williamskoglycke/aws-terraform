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

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}