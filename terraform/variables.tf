variable "tf_state_bucket" {
  description = "Name of the s3 bucket in AWS for storing state"
  default     = "my-api-test-buck"
}

variable "tf_state_lock_table" {
  description = "Name of DynamoDb table for state locking"
  default     = "simpleweb-api-tf-lock"

}

variable "project" {
  description = "Project name for tagging resources"
  default     = "simpleweb-app-api"

}

variable "region" {
  description = "region of ecr"
  default     = "eu-central-1"
}

variable "name" {
  default = "eks-vpc"
}

variable "k8s_version" {
  default = "1.29"
}

variable "cluster_name" {
  default = "eks-simpleweb"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "tags" {
  default = {
    App = "eks-cluster"
  }
}

variable "ecr_repo" {
  default = "express-app-repo"
}

