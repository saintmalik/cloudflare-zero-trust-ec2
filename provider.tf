provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.45.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "s3" {
    bucket = "REPLACE_WITH_YOUR_S3_BUCKET"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "cloudflare" {
  api_token = "YOUR_CLOUDFLARE_TOKEN"
}