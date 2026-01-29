variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "allowed_origin" {
  description = "Allowed origin for CORS configuration"
  type        = string
  default     = "*"
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even with objects"
  type        = bool
  default     = false
}

