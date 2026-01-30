terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}

# =============================================================================
# SECURITY LAYER 1: VPC (Optional)
# =============================================================================
module "vpc" {
  count = var.enable_vpc ? 1 : 0

  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = var.vpc_cidr
}

# =============================================================================
# SECURITY LAYER 2: Secrets Manager (Optional)
# =============================================================================
module "secrets" {
  count = var.enable_secrets_manager && var.twilio_account_sid != "" ? 1 : 0

  source             = "./modules/secrets"
  project_name       = var.project_name
  environment        = var.environment
  twilio_account_sid = var.twilio_account_sid
  twilio_auth_token  = var.twilio_auth_token
}

# =============================================================================
# CORE INFRASTRUCTURE
# =============================================================================
module "cognito" {
  source       = "./modules/cognito"
  project_name = var.project_name
  environment  = var.environment
}

module "dynamo" {
  source       = "./modules/dynamo"
  project_name = var.project_name
  environment  = var.environment
}

module "storage" {
  source         = "./modules/storage"
  project_name   = var.project_name
  environment    = var.environment
  allowed_origin = var.allowed_origin
  force_destroy  = var.environment != "prod"
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment
  build_image  = var.build_image
  image_tag    = local.image_tag
  aws_region   = var.aws_region
}

module "lambda" {
  source       = "./modules/lambda"
  project_name = var.project_name
  environment  = var.environment
  image_uri    = "${module.ecr.repository_url}:${local.image_tag}"

  # VPC Configuration (conditional)
  private_subnet_ids       = var.enable_vpc ? module.vpc[0].private_subnet_ids : []
  lambda_security_group_id = var.enable_vpc ? module.vpc[0].lambda_security_group_id : ""

  # Least-privilege IAM
  dynamodb_table_arns   = module.dynamo.table_arns
  media_bucket_arn      = module.storage.bucket_arn
  enable_s3_access      = true
  secrets_arn           = var.enable_secrets_manager && length(module.secrets) > 0 ? module.secrets[0].twilio_secret_arn : ""
  enable_secrets_access = var.enable_secrets_manager

  environment_variables = local.final_env_vars

  depends_on = [module.ecr]
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
  allowed_origin       = var.allowed_origin
}

module "websocket" {
  source               = "./modules/websocket"
  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
}

# =============================================================================
# SECURITY LAYER 3: WAF (Optional)
# =============================================================================
module "waf" {
  count = var.enable_waf ? 1 : 0

  source                = "./modules/waf"
  project_name          = var.project_name
  environment           = var.environment
  api_gateway_stage_arn = module.api_gateway.stage_arn

  depends_on = [module.api_gateway]
}

# =============================================================================
# SECURITY LAYER 4: Monitoring (Optional)
# =============================================================================
module "monitoring" {
  count = var.enable_monitoring ? 1 : 0

  source               = "./modules/monitoring"
  project_name         = var.project_name
  environment          = var.environment
  vpc_id               = var.enable_vpc ? module.vpc[0].vpc_id : ""
  logs_bucket_id       = module.storage.logs_bucket_name
  logs_bucket_arn      = module.storage.logs_bucket_arn
  media_bucket_arn     = module.storage.bucket_arn
  dynamodb_table_arns  = module.dynamo.table_arns
  api_gateway_name     = module.api_gateway.api_name
  lambda_function_name = module.lambda.function_name

  depends_on = [module.storage]
}

