variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS account to deploy resources"
  type        = string
  sensitive   = true
}

variable "sns_endpoint_email" {
  description = "The endpoint email of the SNS"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment to deploy AWS resources"
  type        = string
  default     = "prod"
}

variable "lambda_sqs_dynamodb_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "POC-Lambda-1"
}

variable "lambda_dynamodbstream_sns_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "POC-Lambda-2"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "orders"
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue"
  type        = string
  default     = "POC-Queue"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "POC-Topic"
}

variable "apigateway_name" {
  description = "The name of the APIGateway"
  type        = string
  default     = "POC-API"
}

variable "apigateway_path" {
  description = "The path of the APIGateway"
  type        = string
  default     = "POC-Queue"
}

variable "apigateway_role_name" {
  description = "The role name of the APIGateway"
  type        = string
  default     = "APIGateway-SQS"
}

variable "lambda_dynamodb_sns_role_name" {
  description = "The role name of the Lambda-DynamoDBStreams-SNS"
  type        = string
  default     = "Lambda-DynamoDBStreams-SNS"
}

variable "lambda_sqs_dynamodb_role_name" {
  description = "The role name of the Lambda-SQS-DynamoDB"
  type        = string
  default     = "Lambda-SQS-DynamoDB"
}
