# DynamoDB Table
resource "aws_dynamodb_table" "my_table" {
  name             = var.dynamodb_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "orderID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "orderID"
    type = "S"
  }
}