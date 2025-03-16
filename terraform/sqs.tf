# SQS Queue
resource "aws_sqs_queue" "my_queue" {
  name = var.sqs_queue_name
}

# Attach a policy to the SQS queue
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow the send role to send messages to the queue
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.my_queue.arn
        Principal = {
          AWS = aws_iam_role.APIGateway-SQS-role.arn
        }
      },
      # Allow the receive role to receive and delete messages from the queue
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = aws_sqs_queue.my_queue.arn
        Principal = {
          AWS = aws_iam_role.Lambda-SQS-DynamoDB-role.arn
        }
      }
    ]
  })
}