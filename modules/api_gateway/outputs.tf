output "base_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}

output "api_name" {
  description = "Name of the API Gateway"
  value       = aws_api_gateway_rest_api.api.name
}

output "stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = aws_api_gateway_stage.stage.arn
}

