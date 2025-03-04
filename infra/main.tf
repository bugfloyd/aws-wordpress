provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner   = "Bugfloyd"
      Service = "Bugfloyd/Websites"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1" # ACM for CloudFront must be in us-east-1
}

module "websites_cert_cloudfront_dns" {
  source = "./websites"

  for_each = var.domains

  domain              = each.key
  hosted_zone_id      = each.value
  instance_public_dns = aws_instance.webserver.public_dns
  logging_bucket      = aws_s3_bucket.cloudfront_logging_bucket.id

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}
