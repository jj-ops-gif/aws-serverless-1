output "lambda_sqs_dynamodb_arn" {
  description = "The ARN of the Lambda function lambda_sqs_dynamodb"
  value       = aws_lambda_function.lambda_sqs_dynamodb.arn
}

output "lambda_dynamodbstream_sns_arn" {
  description = "The ARN of the Lambda function lambda_dynamodbstream_sns"
  value       = aws_lambda_function.lambda_dynamodbstream_sns.arn
}

output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.my_queue.url
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.my_topic.arn
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.my_table.arn
}

output "dynamodb_stream_arn" {
  value = aws_dynamodb_table.my_table.stream_arn
}

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_deployment.sqs_deployment.invoke_url}${var.environment}/${var.apigateway_path}"
}