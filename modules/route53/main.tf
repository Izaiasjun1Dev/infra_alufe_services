data "aws_route53_zone" "selected" {
  count = var.create_zone ? 0 : 1
  name  = var.domain_name
}

resource "aws_route53_zone" "primary" {
  count = var.create_zone ? 1 : 0
  name  = var.domain_name
}

locals {
  zone_id      = var.create_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.selected[0].zone_id
  name_servers = var.create_zone ? aws_route53_zone.primary[0].name_servers : data.aws_route53_zone.selected[0].name_servers
}
