variable "region_name" {
  description = "The AWS region to deploy resources"
  type        = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "lambda_name" {
  description = "The name of the lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "This is the lambda runtime environment"
  type        = string
}