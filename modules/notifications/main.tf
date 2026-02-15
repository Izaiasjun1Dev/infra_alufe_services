resource "aws_sns_topic" "platform_events" {
  name = "${var.project_name}-${var.environment}-platform-events"
}

resource "aws_sqs_queue" "notification_queue" {
  name = "${var.project_name}-${var.environment}-notification-queue"
  visibility_timeout_seconds = 60
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.notification_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "notification_dlq" {
  name = "${var.project_name}-${var.environment}-notification-dlq"
}

resource "aws_sns_topic_subscription" "notification_subscription" {
  topic_arn = aws_sns_topic.platform_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notification_queue.arn
}

resource "aws_sqs_queue_policy" "notification_queue_policy" {
  queue_url = aws_sqs_queue.notification_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.notification_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.platform_events.arn
          }
        }
      }
    ]
  })
}

resource "aws_dynamodb_table" "notifications" {
  name           = "${var.project_name}-${var.environment}-notifications"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "notification_id"
  range_key      = "created_at"

  attribute {
    name = "notification_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "professional_id"
    type = "S"
  }

  global_secondary_index {
    name               = var.professional_id_gsi_name
    hash_key           = "professional_id"
    range_key          = "created_at"
    projection_type    = "ALL"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
