terraform {
  backend "s3" {
    bucket = "wasabi-tfstate"
    key    = "wasabi-run"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "wasabi_tfstate" {
  bucket = "wasabi-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "max"
  version                 = "~> 1.60"
}

resource "aws_acm_certificate" "wasabi_run" {
  domain_name               = "wasabi.run"
  subject_alternative_names = ["*.wasabi.run"]
  validation_method         = "EMAIL"
}
