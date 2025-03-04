# Bugfloyd AWS-WordPress Infrastructure

This repository contains the Terraform configuration and Ansible playbooks for deploying Bugfloyd's AWS infrastructure. It provisions networking, compute resources, security, and backups, along with CloudFront and ACM integrations for website hosting.

## Repository Structure

| Directory                      | Description                                                        |
| ------------------------------ | ------------------------------------------------------------------ |
| [`hostedzones/`](hostedzones/) | Creates AWS Route 53 hosted zones for domain management.           |
| [`infra/`](infra/)             | Main infrastructure for networking, EC2, CloudFront, and security. |

## Prerequisites

- AWS account with necessary permissions.
- Terraform installed ([Download Terraform](https://developer.hashicorp.com/terraform/downloads)).
- AWS CLI installed and configured.

## Steps to Deploy

### 1. Export AWS Profile

Set the AWS profile to deploy resources:

```sh
export AWS_PROFILE=<AWS_PROFILE>
```

### 2. Deploy Remote Backend (State Management)

Create a S3 bucket. We will use this for Terraform remote backend:

```sh
aws s3 mb s3://<TERRAFORM_STATE_S3_BUCKET> \
    --region eu-central-1

aws s3api put-bucket-versioning \
    --bucket <TERRAFORM_STATE_S3_BUCKET> \
    --versioning-configuration Status=Enabled \
    --region eu-central-1
```

Use a unique name for the bucket. Also use a region of your choice.

### 3. Deploy Hosted Zones

Move to `hostedzones/`, follow its readme and create a `backend_config.hcl` and `terraform.tfvars` files and deploy the Route 53 hosted zones:

```sh
cd ../hostedzones
terraform init -backend-config backend_config.hcl
terraform plan -out zones.tfplan
terraform apply "zones.tfplan"
```

### 4. Update Domain Nameservers

After the hosted zones are deployed, update your domain registrar with the name servers output by Terraform. This step ensures that your domains resolve correctly to AWS Route 53.

Retrieve the NS records from the Terraform output:

```sh
terraform output
```

Update your domain registrar with these NS values and wait for propagation (this can take up to 48 hours).

### 5. Deploy Main Infrastructure

Move to `infra/`, follow its readme and create a `backend_config.hcl` and `terraform.tfvars` files and deploy the main resources:

```sh
cd ../infra
terraform init -backend-config backend_config.hcl
terraform plan -out main.tfplan
terraform apply "main.tfplan"
```

### 6. Destroy Infrastructure (If Needed)

To remove all deployed resources:

```sh
terraform destroy
```
