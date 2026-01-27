terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state backend
  backend "s3" {
    # Configuration loaded from backend.hcl
    # Run: terraform init -backend-config=backend.hcl
  }
}

provider "aws" {
  region = var.aws_region
}

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
  source       = "./modules/storage"
  project_name = var.project_name
  environment  = var.environment
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

  environment_variables = local.final_env_vars

  depends_on = [module.ecr]
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
}

module "websocket" {
  source               = "./modules/websocket"
  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
}
