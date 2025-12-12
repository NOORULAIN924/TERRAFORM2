Terraform_lab — Usage

This workspace contains example Terraform configurations to demonstrate AWS infrastructure setup using IaC. It modifies/creates AWS resources; run commands only if you understand AWS charges.

## Prerequisites

1. **AWS Account & Credentials**
   - Have an active AWS account
   - Create AWS Access Key ID and Secret Access Key from IAM console
   - Store credentials securely using AWS CLI or environment variables (NOT in git)

2. **Terraform Installation**
   - Install Terraform v1.0+
   - Verify: `terraform --version`

3. **AWS CLI Configuration**
   - Option A: Use `aws configure` to set credentials interactively
   - Option B: Set environment variables:
     ```powershell
     $env:AWS_ACCESS_KEY_ID = "your-access-key"
     $env:AWS_SECRET_ACCESS_KEY = "your-secret-key"
     $env:AWS_REGION = "us-east-1"
     ```
   - Option C: Use GitHub Secrets for CI/CD (see section below)

## Files and Purpose

- `main.tf` — root configuration (S3 bucket, EC2 instances, data AMI, module instantiations)
- `variables.tf` — variable definitions (bucket_name, key_name, common_tags)
- `terraform.tfvars` — variable values (local use only, add to .gitignore)
- `terraform.tfvars.example` — template for terraform.tfvars (safe to commit)
- `modules/ec2-basic/*` — reusable EC2 module with provisioner support
- `backend_setup.tf` — resources for S3 bucket + DynamoDB table for remote state
- `backend.tf` — example/commented backend block for S3 state
- `.gitignore` — prevents credentials and sensitive files from being committed

## Setup Instructions

### 1. Clone the repository
```powershell
git clone https://github.com/NOORULAIN924/Terraform_lab.git
cd Terraform_lab
```

### 2. Create terraform.tfvars from template
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your bucket name and settings
```

### 3. Initialize Terraform
```powershell
terraform init
terraform validate
```

### 4. Plan and Apply
```powershell
# See what will be created
terraform plan -out plan.tfplan

# Review the plan output, then apply
terraform apply "plan.tfplan"
```

## GitHub Secrets Configuration (for CI/CD)

To use this in GitHub Actions without exposing credentials:

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Add these secrets:
   - `AWS_ACCESS_KEY_ID` - Your AWS Access Key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS Secret Key
   - `AWS_REGION` - us-east-1 (or your preferred region)

4. Use in GitHub Actions workflow:
   ```yaml
   - name: Configure AWS credentials
     uses: aws-actions/configure-aws-credentials@v2
     with:
       aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
       aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
       aws-region: ${{ secrets.AWS_REGION }}
   ```

## Important Security Notes

⚠️ **NEVER commit these files to Git:**
- `terraform.tfvars` (contains bucket names and tags)
- `.aws/credentials` (contains AWS keys)
- `.env` files
- PEM files or key pairs

✅ **Safe to commit:**
- `terraform.tfvars.example` (template only)
- `.gitignore` (prevents accidental commits)
- Terraform code files (*.tf)
- `.terraform.lock.hcl` (tracks provider versions)

## Useful Commands

```powershell
# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# View current state
terraform state list
terraform state show aws_instance.web

# Destroy resources
terraform destroy

# Check for drift (changes made outside Terraform)
terraform plan
```

## Remote State Setup

To use S3 + DynamoDB for remote state:

1. Create backend resources:
```powershell
terraform apply -target=aws_s3_bucket.remote_state -target=aws_dynamodb_table.lock_table
```

2. Update `backend.tf` with your bucket and table names

3. Migrate state:
```powershell
terraform init -migrate-state
```

## Troubleshooting

**Error: "The security token included in the request is invalid"**
- Check AWS credentials are set correctly
- Verify credentials haven't expired
- Use `aws sts get-caller-identity` to test credentials

**Error: "Access Denied" for S3 bucket operations**
- Ensure IAM user has `s3:*` and `dynamodb:*` permissions
- Check bucket policy if creating existing bucket

**Terraform lock file issues**
- Delete `.terraform.lock.hcl` and run `terraform init` again
- Only edit lock file if absolutely necessary

## Support

For issues or questions:
1. Check error message in terminal
2. Review `.gitignore` - ensure sensitive files aren't tracked
3. Validate credentials with: `aws sts get-caller-identity`
4. Run `terraform validate` to check syntax

terraform apply -target=aws_s3_bucket.remote_state -target=aws_dynamodb_table.lock_table
```
- Then edit `backend.tf` to set the `bucket` and `dynamodb_table` names (uncomment the block), and run:
```powershell
terraform init -migrate-state
```

7) Workspaces:
```powershell
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod
terraform workspace select dev
# then apply
terraform apply
```
Resources can use `terraform.workspace` for tagging (this repo already uses `env-${terraform.workspace}` in tags).

8) Provisioner note:
The module has an optional `remote-exec` provisioner (`use_provisioner` variable). To use it you must provide `key_name` in `terraform.tfvars` and the `ssh_private_key` to the module (not recommended to store private keys in plain text). Consider using `user_data` where possible.

9) Destroying resources:
- If you add `lifecycle { prevent_destroy = true }` to a resource, `terraform destroy` will fail for that resource. Remove the lifecycle block to allow destroy.

Commands to destroy everything when ready:
```powershell
terraform destroy
```

Security & credentials:
- The configuration uses the AWS provider. Ensure your AWS credentials are set in environment variables, AWS CLI profile, or the shared credentials file. The assistant did not run Terraform commands or modify your remote AWS account.

If you want, I can now run `terraform init` and `terraform plan` here in the workspace (I will NOT run `apply` without your explicit consent). Would you like me to run `init` and `plan` now?
