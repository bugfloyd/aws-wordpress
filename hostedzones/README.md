# Terraform Hosted Zones Module

This project is a Terraform module for creating AWS Route 53 Hosted Zones using Infrastructure as Code (IaC). It utilizes a remote backend stored in an S3 bucket with DynamoDB for state locking. Ensure the Terraform Remote Backend Infrastructure [init_infra](../init_infra/) is deployed before using this module.

## Prerequisites

1. **AWS CLI** installed and configured.
2. **Terraform** installed.
3. **Terraform Remote Backend Infrastructure** (`init_infra`) must be deployed.

## Configuration

### 1. Export AWS Profile

Ensure you have the correct AWS credentials by setting your profile:

```shell
export AWS_PROFILE=<AWS_PROFILE>
```

### 2. Create `terraform.tfvars`

Create a `terraform.tfvars` file to specify variable values for the hosted zones:

```hcl
websites = [
  "example.com",
  "example.net"
]
```

### 3. Create Backend Configuration File

Before initializing Terraform, create a `backend_config.hcl` file with the following content matching the variables in `init_infra` project:

```hcl
region         = "eu-west-1"
bucket         = "bugfloyd-tf-state"
dynamodb_table = "bugfloyd-tf-state-lock"
```

This configures Terraform to use a remote backend for state management.

## Deployment Steps

### 1. Initialize Terraform

Run the following command to initialize Terraform with the remote backend:

```shell
terraform init -backend-config=backend_config.hcl  # Run once
```

### 2. Plan Deployment

Generate an execution plan to preview changes:

```shell
terraform plan -out zones.tfplan
```

### 3. Apply Deployment

Deploy the changes to AWS:

```shell
terraform apply "zones.tfplan"
```

## Destroying Resources

To delete the hosted zones created by this module, run:

```shell
terraform destroy
```

## Notes

- Ensure the Terraform backend infrastructure (`init_infra`) is deployed before using this module.
- Modify `terraform.tfvars` to add or update hosted zones.
- Terraform state is stored remotely in an S3 bucket with a DynamoDB table for state locking.
