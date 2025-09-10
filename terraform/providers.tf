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
    bucket         = "my-api-test-buck"
    key            = "infra.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile = "simpleweb-api-tf-lock"
  }
}

provider "aws" {
  region = "eu-central-1"
}
