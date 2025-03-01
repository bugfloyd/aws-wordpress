provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Owner   = "Bugfloyd"
      Service = "Bugfloyd/Init"
    }
  }
}
