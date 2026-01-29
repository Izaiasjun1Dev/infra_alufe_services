# S3 Bucket Policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = var.logs_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = var.logs_bucket_arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${var.logs_bucket_arn}/cloudtrail/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "VPCFlowLogsWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${var.logs_bucket_arn}/vpc-flow-logs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "VPCFlowLogsAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = var.logs_bucket_arn
      }
    ]
  })
}

# CloudTrail for API auditing
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-${var.environment}-trail"
  s3_bucket_name                = var.logs_bucket_id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_logging                = true

  depends_on = [aws_s3_bucket_policy.cloudtrail]

  tags = {
    Name        = "${var.project_name}-cloudtrail"
    Environment = var.environment
  }
}

# VPC Flow Logs (conditional)
resource "aws_flow_log" "main" {
  count = var.vpc_id != "" ? 1 : 0

  vpc_id               = var.vpc_id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = "${var.logs_bucket_arn}/vpc-flow-logs/"

  tags = {
    Name        = "${var.project_name}-flow-log"
    Environment = var.environment
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

# CloudWatch Alarm - High 4XX Errors
resource "aws_cloudwatch_metric_alarm" "api_4xx_errors" {
  count = var.api_gateway_name != "" ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-high-4xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "High number of 4XX errors on API Gateway"

  dimensions = {
    ApiName = var.api_gateway_name
    Stage   = var.environment
  }

  alarm_actions = var.alarm_actions

  tags = {
    Name        = "${var.project_name}-4xx-alarm"
    Environment = var.environment
  }
}

# CloudWatch Alarm - Lambda Errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count = var.lambda_function_name != "" ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "High number of Lambda errors"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  alarm_actions = var.alarm_actions

  tags = {
    Name        = "${var.project_name}-lambda-errors-alarm"
    Environment = var.environment
  }
}

# CloudWatch Alarm - Lambda Duration (timeout warning)
resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  count = var.lambda_function_name != "" ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-lambda-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Average"
  threshold           = 25000 # 25 seconds (Lambda timeout is usually 30s)
  alarm_description   = "Lambda duration approaching timeout"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  alarm_actions = var.alarm_actions

  tags = {
    Name        = "${var.project_name}-lambda-duration-alarm"
    Environment = var.environment
  }
}
