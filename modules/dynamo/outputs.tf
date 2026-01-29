output "table_name" {
  value = aws_dynamodb_table.professionals.name
}

output "appointments_table_name" {
  value = aws_dynamodb_table.appointments.name
}

output "twilio_numbers_table_name" {
  value = aws_dynamodb_table.twilio_numbers.name
}

output "connections_table_name" {
  value = aws_dynamodb_table.connections.name
}

output "messages_table" {
  value = aws_dynamodb_table.messages.name
}

output "agents_table" {
  value = aws_dynamodb_table.agents.name
}

output "services_table" {
  value = aws_dynamodb_table.services.name
}

# All table ARNs for Lambda IAM policies
output "table_arns" {
  description = "List of all DynamoDB table ARNs"
  value = [
    aws_dynamodb_table.professionals.arn,
    aws_dynamodb_table.appointments.arn,
    aws_dynamodb_table.twilio_numbers.arn,
    aws_dynamodb_table.connections.arn,
    aws_dynamodb_table.messages.arn,
    aws_dynamodb_table.agents.arn,
    aws_dynamodb_table.services.arn
  ]
}

