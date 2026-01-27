resource "aws_cognito_user_pool" "pool" {
  name = "${var.project_name}-${var.environment}-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Verifique seu e-mail - Projeto X"
    email_message        = <<EOT
<html>
<body style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0a0a0a; color: #ffffff; padding: 40px; margin: 0;">
    <div style="max-width: 600px; margin: 0 auto; background: #121212; border: 1px solid #333; border-radius: 24px; padding: 40px; text-align: center;">
        <div style="color: #8b5cf6; font-size: 24px; font-weight: 900; margin-bottom: 30px; letter-spacing: -1px;">PROJETO X</div>
        <h1 style="font-size: 28px; font-weight: 800; margin-bottom: 10px; color: #ffffff;">Seu código de acesso</h1>
        <p style="color: #a1a1aa; line-height: 1.6; margin-bottom: 30px;">Olá! Use o código abaixo para confirmar sua conta e começar sua jornada no Alufe Service.</p>
        <div style="background: #1e1e1e; border: 2px dashed #8b5cf6; border-radius: 16px; padding: 20px; font-size: 36px; font-weight: 900; color: #8b5cf6; letter-spacing: 10px; margin: 20px 0; display: inline-block; width: 80%;">{####}</div>
        <p style="color: #a1a1aa; line-height: 1.6; margin-bottom: 30px;">Este código expira em breve. Se você não solicitou este registro, pode ignorar este e-mail.</p>
        <div style="margin-top: 40px; font-size: 12px; color: #52525b;">
            &copy; 2026 Projeto X - Atendimento Inteligente<br>
            Construído para profissionais de elite.
        </div>
    </div>
</body>
</html>
EOT
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.project_name}-${var.environment}-client"

  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}
