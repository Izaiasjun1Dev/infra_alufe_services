resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# VPC Execution Role (required when Lambda runs in VPC)
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  count      = length(var.private_subnet_ids) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "function" {
  function_name = "${var.project_name}-${var.environment}-backend"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.image_uri
  timeout       = 30
  memory_size   = 512

  # VPC Configuration (conditional)
  dynamic "vpc_config" {
    for_each = length(var.private_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.private_subnet_ids
      security_group_ids = [var.lambda_security_group_id]
    }
  }

  environment {
    variables = var.environment_variables
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend"
    Environment = var.environment
  }
}

# Restricted DynamoDB Policy (least privilege)
resource "aws_iam_policy" "dynamodb_restricted" {
  count       = length(var.dynamodb_table_arns) > 0 ? 1 : 0
  name        = "${var.project_name}-${var.environment}-dynamodb-policy"
  description = "Restricted DynamoDB access for Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = concat(
          var.dynamodb_table_arns,
          [for arn in var.dynamodb_table_arns : "${arn}/index/*"]
        )
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo_restricted" {
  count      = length(var.dynamodb_table_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.dynamodb_restricted[0].arn
  role       = aws_iam_role.lambda_role.name
}

# Fallback to full access if no ARNs provided (backwards compatibility)
resource "aws_iam_role_policy_attachment" "lambda_dynamo_full" {
  count      = length(var.dynamodb_table_arns) == 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_role.name
}

# Restricted S3 Policy (least privilege)
resource "aws_iam_policy" "s3_restricted" {
  count       = var.enable_s3_access ? 1 : 0
  name        = "${var.project_name}-${var.environment}-s3-policy"
  description = "Restricted S3 access for Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.media_bucket_arn,
          "${var.media_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_restricted" {
  count      = var.enable_s3_access ? 1 : 0
  policy_arn = aws_iam_policy.s3_restricted[0].arn
  role       = aws_iam_role.lambda_role.name
}

# Fallback to full access if no ARN provided (backwards compatibility)
resource "aws_iam_role_policy_attachment" "lambda_s3_full" {
  count      = !var.enable_s3_access ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_role.name
}

# Secrets Manager Access
resource "aws_iam_policy" "secrets_access" {
  count       = var.enable_secrets_access ? 1 : 0
  name        = "${var.project_name}-${var.environment}-secrets-policy"
  description = "Allow Lambda to read secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.secrets_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_secrets" {
  count      = var.enable_secrets_access ? 1 : 0
  policy_arn = aws_iam_policy.secrets_access[0].arn
  role       = aws_iam_role.lambda_role.name
}

# Bedrock Access
resource "aws_iam_policy" "lambda_bedrock" {
  name        = "${var.project_name}-${var.environment}-bedrock-policy"
  description = "Allow Lambda to call Amazon Bedrock"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_bedrock" {
  policy_arn = aws_iam_policy.lambda_bedrock.arn
  role       = aws_iam_role.lambda_role.name
}

# API Gateway Management (for WebSocket)
resource "aws_iam_policy" "apigateway_management" {
  name        = "${var.project_name}-${var.environment}-apigw-management-policy"
  description = "Allow Lambda to manage WebSocket connections"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "execute-api:ManageConnections"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_apigateway" {
  policy_arn = aws_iam_policy.apigateway_management.arn
  role       = aws_iam_role.lambda_role.name
}

# SNS Publish Policy
resource "aws_iam_policy" "sns_publish" {
  count       = length(var.sns_topic_arns) > 0 ? 1 : 0
  name        = "${var.project_name}-${var.environment}-sns-policy"
  description = "Allow Lambda to publish to SNS topics"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = var.sns_topic_arns
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sns" {
  count      = length(var.sns_topic_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.sns_publish[0].arn
  role       = aws_iam_role.lambda_role.name
}

# Notifications Table Policy (if separate from main table list)
resource "aws_iam_policy" "notifications_table" {
  count       = var.notifications_table_arn != "" ? 1 : 0
  name        = "${var.project_name}-${var.environment}-notifications-policy"
  description = "Access to notifications table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.notifications_table_arn,
          "${var.notifications_table_arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_notifications" {
  count      = var.notifications_table_arn != "" ? 1 : 0
  policy_arn = aws_iam_policy.notifications_table[0].arn
  role       = aws_iam_role.lambda_role.name
}
