resource "aws_iam_policy" "Lambda-Write-DynamoDB" {
  name        = "Lambda-Write-DynamoDB"
  description = "Lambda-Write-DynamoDB policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DescribeTable"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_policy" "Lambda-SNS-Publish" {
  name        = "Lambda-SNS-Publish"
  description = "Lambda-SNS-Publish policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish",
        "sns:GetTopicAttributes",
        "sns:ListTopics"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_policy" "Lambda-DynamoDBStreams-Read" {
  name        = "Lambda-DynamoDBStreams-Read"
  description = "Lambda-DynamoDBStreams-Read policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetShardIterator",
        "dynamodb:DescribeStream",
        "dynamodb:ListStreams",
        "dynamodb:GetRecords"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_policy" "Lambda-Read-SQS" {
  name        = "Lambda-Read-SQS"
  description = "Lambda-Read-SQS policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}
