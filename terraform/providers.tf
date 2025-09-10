terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  backend "s3" {
    bucket         = "my-api-test-buck-cd"
    key            = "infra.tfstate.cd"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "simpleweb-api-tf-lock"
  }
}

provider "aws" {
  region = "eu-central-1"
}
