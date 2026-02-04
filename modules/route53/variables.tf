variable "domain_name" { type = string }
variable "environment" { type = string }
variable "create_zone" {
  type    = bool
  default = false
}
