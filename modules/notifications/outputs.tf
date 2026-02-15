output "sns_topic_arn" { value = aws_sns_topic.platform_events.arn }
output "sqs_queue_arn" { value = aws_sqs_queue.notification_queue.arn }
output "notifications_table_name" { value = aws_dynamodb_table.notifications.name }
