output "twilio_secret_arn" {
  description = "ARN of the Twilio secret"
  value       = aws_secretsmanager_secret.twilio.arn
}

output "twilio_secret_name" {
  description = "Name of the Twilio secret"
  value       = aws_secretsmanager_secret.twilio.name
}
