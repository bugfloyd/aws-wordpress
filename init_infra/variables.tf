variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "terraform_state_bucket" {
  description = "The AWS S3 bucket used to store terraform state"
  type        = string
}
