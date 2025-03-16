# Lambda function read message from SQS and write to the DynamDB
resource "aws_lambda_function" "lambda_sqs_dynamodb" {
  function_name = var.lambda_sqs_dynamodb_name
  role          = aws_iam_role.Lambda-SQS-DynamoDB-role.arn
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("../lambda/lambda_sqs_dynamodb/lambda.zip")

  filename = "../lambda/lambda_sqs_dynamodb/lambda.zip"
}

# Lambda function reads DynamoDB stream and publish a message to the SNS topic
resource "aws_lambda_function" "lambda_dynamodbstream_sns" {
  function_name = var.lambda_dynamodbstream_sns_name
  role          = aws_iam_role.Lambda-DynamoDBStreams-SNS-role.arn
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("../lambda/lambda_dynamodbstream_sns/lambda.zip")

  filename = "../lambda/lambda_dynamodbstream_sns/lambda.zip"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.my_topic.arn
    }
  }
}

# Trigger lamda by a SQS
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.my_queue.arn
  function_name    = aws_lambda_function.lambda_sqs_dynamodb.arn
  batch_size       = 10
}

# Trigger lamda by a DynamoDB stream
resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn = aws_dynamodb_table.my_table.stream_arn
  function_name     = aws_lambda_function.lambda_dynamodbstream_sns.arn
  starting_position = "TRIM_HORIZON"  # or "LATEST"
  batch_size        = 10
}