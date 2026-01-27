output "websocket_url" {
  value = "${aws_apigatewayv2_api.websocket.api_endpoint}/${aws_apigatewayv2_stage.environment.name}"
}

output "execution_arn" {
  value = aws_apigatewayv2_api.websocket.execution_arn
}
