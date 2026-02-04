variable "project_name" { type = string }
variable "environment" { type = string }
variable "github_token" { type = string }
variable "repository_url" { type = string }
variable "domain_name" {
  type    = string
  default = ""
}
variable "branch_name" {
  type    = string
  default = "main"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}
