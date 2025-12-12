# Terraform AWS Static Website Deployment

This project demonstrates deploying a static website to AWS S3 using Terraform, with automated CI/CD via GitHub Actions.

## What We Accomplished

### 1. Project Setup
- Initialized a Git repository for version control.
- Created Terraform configuration files:
  - `main.tf`: Defines AWS resources (S3 bucket, DynamoDB table, bucket policies, website configuration).
  - `backend.tf`: Configures S3 backend for state management.
  - `variables.tf`: Defines input variables.
  - `outputs.tf`: Outputs bucket name and website URL.
  - `providers.tf`: Specifies AWS provider.

### 2. Infrastructure as Code
- **S3 Bucket**: Created a bucket for hosting the static website with public read access.
- **DynamoDB Table**: Set up a table for Terraform state locking.
- **Website Configuration**: Enabled static website hosting on S3 with index and error documents.
- **Backend Configuration**: Used S3 for remote state storage and DynamoDB for locking.

### 3. Manual Deployment
- Configured AWS credentials locally.
- Created required AWS resources (S3 bucket and DynamoDB table).
- Ran `terraform init`, `terraform plan`, and `terraform apply` to deploy the infrastructure.
- Uploaded the initial `index.html` to the S3 bucket.

### 4. CI/CD with GitHub Actions
- Set up GitHub Actions workflows:
  - `ci.yml`: Validates Terraform code on pull requests.
  - `cd.yml`: Applies changes on pushes to the main branch.
- Configured workflows to create necessary AWS resources if they don't exist.
- Added steps for Terraform initialization, planning, and application.

### 5. Website Updates
- Updated `index.html` with a modern, responsive design featuring:
  - Gradient background
  - Glassmorphism-style container
  - Hover effects and mobile responsiveness
- Committed and pushed changes to trigger automatic deployments.

### 6. Troubleshooting
- Resolved backend initialization issues by creating required AWS resources.
- Fixed GitHub Actions authentication errors by configuring environment-level secrets.
- Updated workflow triggers to match the repository's default branch.

## Architecture

```
GitHub Repository
├── Terraform Code (main.tf, backend.tf, etc.)
├── GitHub Actions Workflows (.github/workflows/)
└── Static Website Files (index.html)

↓ Push to GitHub

GitHub Actions (CI/CD)
├── Validate Code (terraform validate)
├── Plan Changes (terraform plan)
└── Apply Changes (terraform apply)

↓ Deploys to AWS

AWS Infrastructure
├── S3 Bucket (Website Hosting)
├── DynamoDB Table (State Locking)
├── S3 Backend (State Storage)
└── Public Website Access
```

## Prerequisites

- AWS Account with appropriate permissions
- GitHub Repository
- Terraform installed locally
- AWS CLI configured

## Local Development

1. Clone the repository
2. Configure AWS credentials
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`

## Deployment

The website is automatically deployed when changes are pushed to the main branch via GitHub Actions.

Website URL: http://noor-terraform-123.s3-website.us-east-2.amazonaws.com/

## Key Learnings

- Infrastructure as Code with Terraform
- Remote state management with S3 backend
- CI/CD pipeline setup with GitHub Actions
- AWS resource management (S3, DynamoDB)
- Static website hosting on S3
- Troubleshooting deployment issues

## Technologies Used

- Terraform
- AWS (S3, DynamoDB, IAM)
- GitHub Actions
- HTML/CSS (for the website)

This project showcases a complete DevOps workflow for deploying and managing cloud infrastructure and applications.
