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
