variable "domain" {
  description = "Domain name for SSL certificate and redirects"
  type        = string
}

variable "hosted_zone_id" {
  description = "The Hosted Zone ID for the domain"
  type        = string
}

variable "instance_public_dns" {
  description = "The public DNS for the EC2 instance"
  type        = string
}

variable "logging_bucket" {
  description = "S3 bucket used for CloudFront distribution logs"
  type        = string
}
