output "api_url" {
  value       = module.api_gateway.base_url
  description = "Base URL for the backend API"
}

output "websocket_url" {
  value       = module.websocket.websocket_url
  description = "URL for the WebSocket API"
}

output "cognito_user_pool_id" {
  value       = module.cognito.user_pool_id
  description = "AWS Cognito User Pool ID"
}

output "cognito_client_id" {
  value       = module.cognito.client_id
  description = "AWS Cognito Client ID"
}
