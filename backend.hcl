# Backend configuration for Terraform S3 state
# Usage: terraform init -backend-config=backend.hcl

bucket         = "alufe-dev-terraform-state"
key            = "terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "alufe-dev-terraform-locks"
encrypt        = true
