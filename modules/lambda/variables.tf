variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

# VPC Configuration (optional - for network isolation)
variable "private_subnet_ids" {
  description = "List of private subnet IDs for Lambda VPC configuration"
  type        = list(string)
  default     = []
}

variable "lambda_security_group_id" {
  description = "Security group ID for Lambda in VPC"
  type        = string
  default     = ""
}

# Security - Resource ARNs for least privilege policies
variable "dynamodb_table_arns" {
  description = "List of DynamoDB table ARNs for restricted access"
  type        = list(string)
  default     = []
}

variable "media_bucket_arn" {
  description = "ARN of the media S3 bucket"
  type        = string
  default     = ""
}

variable "enable_s3_access" {
  description = "Enable S3 access policy creation"
  type        = bool
  default     = false
}

variable "secrets_arn" {
  description = "ARN of the secrets in Secrets Manager"
  type        = string
  default     = ""
}

variable "enable_secrets_access" {
  description = "Enable Secrets Manager access policy creation"
  type        = bool
  default     = false
}

variable "sns_topic_arns" {
  description = "List of SNS topic ARNs to allow publishing to"
  type        = list(string)
  default     = []
}

variable "notifications_table_arn" {
  description = "ARN of the notifications DynamoDB table"
  type        = string
  default     = ""
}
