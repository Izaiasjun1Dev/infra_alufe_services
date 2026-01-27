# Backend Setup Instructions

This directory contains the bootstrap configuration to create the S3 bucket and DynamoDB table needed for Terraform remote state.

## First-time Setup

1. **Initialize and apply the backend setup**:
   ```bash
   cd backend-setup
   terraform init
   terraform apply
   ```

2. **Note the outputs** - You'll need the bucket name and DynamoDB table name.

3. **Configure the main infrastructure**:
   - The `backend.hcl` file in the parent directory will be created automatically
   - Add the backend configuration to `main.tf`

4. **Initialize the main infrastructure with remote backend**:
   ```bash
   cd ..
   terraform init -backend-config=backend.hcl
   ```

5. **Migrate local state to S3** (if you have existing state):
   - Terraform will prompt you to migrate
   - Type "yes" to confirm

## Important Notes

- This setup only needs to be run **once** per environment
- The S3 bucket has versioning enabled to track state history
- The DynamoDB table prevents concurrent modifications (state locking)
- Bucket encryption is enabled by default (AES256)
- Public access is blocked for security

## Cleanup

To destroy the backend resources (⚠️ **WARNING**: This will delete your state storage!):
```bash
cd backend-setup
terraform destroy
```
