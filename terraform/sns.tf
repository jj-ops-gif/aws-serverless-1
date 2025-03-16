# SNS Topic
resource "aws_sns_topic" "my_topic" {
  name = var.sns_topic_name
}

# SNS - subscribe an Email Address
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint_email
  
  # Confirm that the subscription is enabled
  confirmation_timeout_in_minutes = 5
}