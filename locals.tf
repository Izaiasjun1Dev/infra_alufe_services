locals {
  # Use the provided image_tag if available (from CI/CD), otherwise calculate it
  calculated_tag = substr(sha1(join("", [
    for f in sort(setunion(
      fileset("../back", "src/**"),
      fileset("../back", "pyproject.toml"),
      fileset("../back", "Dockerfile")
    )) : filesha1("../back/${f}")
  ])), 0, 8)

  image_tag = var.image_tag != "" ? var.image_tag : local.calculated_tag

  # Dynamic environment variables merging infrastructure outputs and user vars
  infra_env_vars = {
    ENVIRONMENT           = var.environment
    STAGE                 = var.environment
    COGNITO_USER_POOL_ID  = module.cognito.user_pool_id
    COGNITO_CLIENT_ID     = module.cognito.client_id
    PROFESSIONALS_TABLE   = module.dynamo.table_name
    APPOINTMENTS_TABLE    = module.dynamo.appointments_table_name
    TWILIO_NUMBERS_TABLE  = module.dynamo.twilio_numbers_table_name
    CONNECTIONS_TABLE     = module.dynamo.connections_table_name
    MESSAGES_TABLE        = module.dynamo.messages_table
    AGENTS_TABLE          = module.dynamo.agents_table
    SERVICES_TABLE        = module.dynamo.services_table
    PLATFORM_CONFIG_TABLE = module.dynamo.platform_config_table
    MEDIA_BUCKET          = module.storage.bucket_name
    WEBSOCKET_URL         = module.websocket.websocket_url
    FORCE_REDEPLOY        = local.image_tag
    CORS_ORIGINS          = var.allowed_origin
  }

  # Twilio credentials - use direct env vars if Secrets Manager is disabled
  twilio_env_vars = var.enable_secrets_manager ? {} : {
    TWILIO_ACCOUNT_SID = var.twilio_account_sid
    TWILIO_AUTH_TOKEN  = var.twilio_auth_token
  }

  # Secrets Manager configuration - tells the Python app where to find secrets
  secrets_env_vars = var.enable_secrets_manager && length(module.secrets) > 0 ? {
    SECRETS_MANAGER_SECRET_ID = module.secrets[0].twilio_secret_name
  } : {}

  final_env_vars = merge(
    local.infra_env_vars,
    local.twilio_env_vars,
    local.secrets_env_vars,
    var.env_vars
  )
}

