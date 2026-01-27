variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "projeto-x"
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

variable "twilio_account_sid" {
  type    = string
  default = ""
}

variable "twilio_auth_token" {
  type    = string
  default = ""
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Additional environment variables to pass to the backend"
}
