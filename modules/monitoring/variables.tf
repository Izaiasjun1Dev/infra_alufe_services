variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for flow logs"
  type        = string
  default     = ""
}

variable "logs_bucket_id" {
  description = "S3 bucket ID for storing logs"
  type        = string
}

variable "logs_bucket_arn" {
  description = "S3 bucket ARN for storing logs"
  type        = string
}

variable "media_bucket_arn" {
  description = "ARN of the media S3 bucket"
  type        = string
  default     = ""
}

variable "dynamodb_table_arns" {
  description = "List of DynamoDB table ARNs"
  type        = list(string)
  default     = []
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = ""
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarm triggers (e.g., SNS topics)"
  type        = list(string)
  default     = []
}
