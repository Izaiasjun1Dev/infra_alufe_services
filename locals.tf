locals {
  # Calculate a unique tag based on source code and config only (avoid volatile files)
  image_tag = substr(sha1(join("", [
    for f in sort(setunion(
      fileset("../back", "src/**"),
      fileset("../back", "pyproject.toml"),
      fileset("../back", "Dockerfile")
    )) : filesha1("../back/${f}")
  ])), 0, 8)

  # Dynamic environment variables merging infrastructure outputs and user vars
  infra_env_vars = {
    ENVIRONMENT          = var.environment
    COGNITO_USER_POOL_ID = module.cognito.user_pool_id
    COGNITO_CLIENT_ID    = module.cognito.client_id
    PROFESSIONALS_TABLE  = module.dynamo.table_name
    APPOINTMENTS_TABLE   = module.dynamo.appointments_table_name
    TWILIO_NUMBERS_TABLE = module.dynamo.twilio_numbers_table_name
    CONNECTIONS_TABLE    = module.dynamo.connections_table_name
    MESSAGES_TABLE       = module.dynamo.messages_table
    AGENTS_TABLE         = module.dynamo.agents_table
    SERVICES_TABLE       = module.dynamo.services_table
    MEDIA_BUCKET         = module.storage.bucket_name
    WEBSOCKET_URL        = module.websocket.websocket_url
    TWILIO_ACCOUNT_SID   = var.twilio_account_sid
    TWILIO_AUTH_TOKEN    = var.twilio_auth_token
    FORCE_REDEPLOY       = var.build_image ? local.image_tag : "static"
  }

  final_env_vars = merge(local.infra_env_vars, var.env_vars)
}
