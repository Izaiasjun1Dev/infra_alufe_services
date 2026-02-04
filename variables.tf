variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "luv"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "build_image" {
  type        = bool
  default     = true
  description = "Whether to build and push the docker image"
}

variable "image_tag" {
  type        = string
  default     = ""
  description = "Override the default image tag (calculated from hash) with a specific version (e.g., from CI/CD)"
}

variable "twilio_account_sid" {
  type      = string
  default   = ""
  sensitive = true
}

variable "twilio_auth_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Additional environment variables to pass to the backend"
}

# Security Configuration
variable "enable_vpc" {
  type        = bool
  default     = false
  description = "Enable VPC for Lambda network isolation"
}

variable "enable_waf" {
  type        = bool
  default     = false
  description = "Enable WAF protection for API Gateway"
}

variable "enable_secrets_manager" {
  type        = bool
  default     = false
  description = "Enable Secrets Manager for storing credentials"
}

variable "enable_monitoring" {
  type        = bool
  default     = false
  description = "Enable CloudTrail and CloudWatch monitoring"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}

variable "allowed_origin" {
  type        = string
  default     = "*"
  description = "Allowed origin for CORS (e.g., https://yourapp.com)"
}

variable "github_token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "GitHub Personal Access Token for Amplify"
}

variable "front_repository_url" {
  type        = string
  default     = "https://github.com/Izaiasjun1Dev/front_sua_assistente"
  description = "GitHub repository URL for the frontend"
}

variable "domain_name" {
  type        = string
  default     = "luv.com.br"
  description = "Base domain name for the application"
}

variable "enable_amplify" {
  type        = bool
  default     = false
  description = "Enable AWS Amplify for frontend hosting"
}

variable "create_route53_zone" {
  type        = bool
  default     = false
  description = "Create a new Route53 Hosted Zone"
}

