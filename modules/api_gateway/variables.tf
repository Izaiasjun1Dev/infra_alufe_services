variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "allowed_origin" {
  type        = string
  default     = "*"
  description = "Allowed origin for CORS"
}
