# Bugfloyd AWS Infrastructure

This repository contains the Terraform configuration for deploying Bugfloyd's AWS infrastructure. It provisions networking, compute resources, security, and backups, along with CloudFront and ACM integrations for website hosting.

## Features

- **VPC and Networking**: Creates a VPC, subnets, route tables, and an Internet Gateway.
- **Web Server Deployment**: Launches an EC2 instance using an OpenLiteSpeed AMI.
- **CloudFront & ACM**: Provisions CloudFront distributions and SSL certificates.
- **S3 Backups**: Configures S3 buckets for logging and database/website backups.
- **Security**: Restricts SSH access to admin IPs and configures security groups.

## Prerequisites

- AWS account with necessary permissions.
- Terraform installed ([Download Terraform](https://developer.hashicorp.com/terraform/downloads)).
- AWS CLI installed and configured.
- **Terraform Remote S3 Backend** must be deployed.

## Variables

This project uses the following Terraform variables, defined in `terraform.tfvars`:

| Variable                         | Description                                    |
| -------------------------------- | ---------------------------------------------- |
| `region`                         | AWS region for deployment.                     |
| `ols_image_id`                   | AMI ID for web server EC2 instance             |
| `admin_ips`                      | List of admin IPs allowed SSH access.          |
| `admin_public_key`               | Public key for SSH authentication.             |
| `cloudfront_logging_bucket_name` | S3 bucket for CloudFront logs.                 |
| `domains`                        | Map of domain names and Route 53 hosted zones. |

Example `terraform.tfvars` file:

```hcl
region                         = "eu-central-1"
ols_image_id                   = "ami-06132404beb88b9d2" # Your AMI ID
admin_ips                      = ["X.X.X.X/32", "Y.Y.Y.Y/32"]
admin_public_key               = "ssh-rsa AAA...32U= bugfloyd@laptop"
cloudfront_logging_bucket_name = "bugfloyd-websites.logs"
domains = {
  "bugfloyd.com" = "<HOSTED ZONE ID FROM HOSTED ZONES DEPLOYMENT>"
}
```

## Usage

### 1. Export AWS Profile

Export the AWS profile to deploy resources:

```sh
export AWS_PROFILE=<AWS_PROFILE>
```

### 2. Initialize Terraform

Create a backend configuration file named `backend_config.hcl`:

```hcl
region         = "<AWS_REGION>"
bucket         = "<S3_TERRAFORM_STATE_BUCKET_NAME>"
```

Run Terraform initialization:

```sh
terraform init -backend-config backend_config.hcl
```

### 3. Plan Deployment

Generate an execution plan to preview changes:

```sh
terraform plan -out main.tfplan
```

### 4. Apply Changes

Deploy the infrastructure:

```sh
terraform apply "main.tfplan"
```

### 5. Destroy Infrastructure

To remove all deployed resources:

```sh
terraform destroy
```
