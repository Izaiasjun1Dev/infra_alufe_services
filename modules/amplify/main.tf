resource "aws_amplify_app" "this" {
  name         = "${var.project_name}-${var.environment}-front"
  repository   = var.repository_url
  access_token = var.github_token

  # Enable auto-build when connected to repository
  enable_branch_auto_build = true

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }

  environment_variables = var.env_vars
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.this.id
  branch_name = var.branch_name

  framework         = "React"
  stage             = var.environment == "prod" ? "PRODUCTION" : "DEVELOPMENT"
  enable_auto_build = true
}

