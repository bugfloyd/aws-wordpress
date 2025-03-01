# Terraform Remote Backend Infrastructure

This Terraform module sets up the base infrastructure required for storing Terraform state remotely using AWS S3 and DynamoDB for state locking.

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed ([Download Terraform](https://www.terraform.io/downloads))
- AWS CLI configured with necessary credentials

## Export AWS Profile

Before deploying the resources, ensure the correct AWS profile is set:

```shell
export AWS_PROFILE=<AWS_PROFILE>
```

## Deploy Initialization Resources

This setup creates an S3 bucket to store Terraform state and a DynamoDB table to manage state locking.

### Configure Variables

Create a `terraform.tfvars` file with the required configuration values like this:

```hcl
aws_region                          = "<AWS_REGION>"
terraform_state_bucket              = "<TERRAFORM_STATE_S3_BUCKET_NAME>"
terraform_state_lock_dynamodb_table = "<TERRAFORM_STATE_DYNAMODB_TABLE_NAME>"
```

### Initialize and Apply Terraform Configuration

Run the following commands to deploy the remote backend resources:

```shell
terraform init  # Run once to initialize the working directory
terraform plan -out init.tfplan  # Generate execution plan
terraform apply "init.tfplan"  # Apply the changes
```

**Note:** The Terraform state for this initialization stack is stored locally.

## Cleanup

To destroy the resources created by this stack, run:

```shell
terraform destroy
```

## Next Steps

After successfully deploying the remote backend infrastructure, configure your main Terraform stack to use this backend by adding the appropriate backend configuration.
