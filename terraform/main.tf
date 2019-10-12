provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.23.0"
}

terraform {
  backend "s3" {
    bucket  = "ort-terraform"
    region  = "ap-northeast-1"
    key     = "scraping_service/terraform.tfstate"
    encrypt = true
  }
}
