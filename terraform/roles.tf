resource "aws_iam_role" "Lambda-SQS-DynamoDB-role" {
  name = var.lambda_sqs_dynamodb_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach-Lambda-Read-SQS" {
  role       = aws_iam_role.Lambda-SQS-DynamoDB-role.name
  policy_arn = aws_iam_policy.Lambda-Read-SQS.arn
}

resource "aws_iam_role_policy_attachment" "attach-Lambda-Write-DynamoDB" {
  role       = aws_iam_role.Lambda-SQS-DynamoDB-role.name
  policy_arn = aws_iam_policy.Lambda-Write-DynamoDB.arn
}

resource "aws_iam_role" "Lambda-DynamoDBStreams-SNS-role" {
  name = var.lambda_dynamodb_sns_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach-Lambda-SNS-Publish" {
  role       = aws_iam_role.Lambda-DynamoDBStreams-SNS-role.name
  policy_arn = aws_iam_policy.Lambda-SNS-Publish.arn
}

resource "aws_iam_role_policy_attachment" "attach-Lambda-DynamoDBStreams-Read" {
  role       = aws_iam_role.Lambda-DynamoDBStreams-SNS-role.name
  policy_arn = aws_iam_policy.Lambda-DynamoDBStreams-Read.arn
}

resource "aws_iam_role" "APIGateway-SQS-role" {
  name = var.apigateway_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach-AmazonAPIGatewayPushToCloudWatchLogs" {
  role       = aws_iam_role.APIGateway-SQS-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
