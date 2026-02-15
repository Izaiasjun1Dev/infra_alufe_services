variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "professional_id_gsi_name" {
  type    = string
  default = "professional_id-created_at"
}
