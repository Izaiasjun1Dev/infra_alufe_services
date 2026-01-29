# Twilio Credentials Secret
resource "aws_secretsmanager_secret" "twilio" {
  name                    = "${var.project_name}/${var.environment}/twilio"
  description             = "Twilio API credentials"
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name        = "${var.project_name}-twilio-secret"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "twilio" {
  secret_id = aws_secretsmanager_secret.twilio.id
  secret_string = jsonencode({
    account_sid = var.twilio_account_sid
    auth_token  = var.twilio_auth_token
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}
