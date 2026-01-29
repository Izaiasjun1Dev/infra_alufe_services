output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = var.vpc_id != "" ? aws_flow_log.main[0].id : null
}
