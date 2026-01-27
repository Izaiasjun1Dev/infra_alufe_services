resource "aws_dynamodb_table" "professionals" {
  name         = "${var.project_name}-${var.environment}-professionals"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "email"
    projection_type = "ALL"
  }

  tags = {
    Name        = "${var.project_name}-professionals"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "appointments" {
  name         = "${var.project_name}-${var.environment}-appointments"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "professional_id"
  range_key    = "appointment_id"

  attribute {
    name = "professional_id"
    type = "S"
  }

  attribute {
    name = "appointment_id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    projection_type = "ALL"
  }

  tags = {
    Name        = "${var.project_name}-appointments"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "twilio_numbers" {
  name         = "${var.project_name}-${var.environment}-twilio-numbers"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "professional_id"
  range_key    = "phone_number"

  attribute {
    name = "professional_id"
    type = "S"
  }

  attribute {
    name = "phone_number"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    projection_type = "ALL"
  }

  tags = {
    Name        = "${var.project_name}-twilio-numbers"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "connections" {
  name         = "${var.project_name}-${var.environment}-connections"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connection_id"

  attribute {
    name = "connection_id"
    type = "S"
  }

  attribute {
    name = "professional_id"
    type = "S"
  }

  global_secondary_index {
    name            = "ProfessionalIndex"
    hash_key        = "professional_id"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    Name        = "${var.project_name}-connections"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "messages" {
  name         = "${var.project_name}-${var.environment}-messages"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "conversation_id"
  range_key    = "created_at"

  attribute {
    name = "conversation_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-messages"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "agents" {
  name         = "${var.project_name}-${var.environment}-agents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "professional_id"
  range_key    = "agent_id"

  attribute {
    name = "professional_id"
    type = "S"
  }

  attribute {
    name = "agent_id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-agents"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "services" {
  name         = "${var.project_name}-${var.environment}-services"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "professional_id"
  range_key    = "id"

  attribute {
    name = "professional_id"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-services"
    Environment = var.environment
  }
}
