# VPC Module

Creates a VPC with public and private subnets for Lambda network isolation.

## Resources Created
- VPC with DNS support
- Public subnets (for NAT Gateway)
- Private subnets (for Lambda)
- Internet Gateway
- NAT Gateway
- Route tables

## Usage

```hcl
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "10.0.0.0/16"
}
```
