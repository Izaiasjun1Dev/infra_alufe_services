variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "build_image" {
  type    = bool
  default = false
}

variable "image_tag" {
  type = string
}

variable "aws_region" {
  type = string
}
