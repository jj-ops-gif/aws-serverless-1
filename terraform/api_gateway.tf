resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.APIGateway-SQS-role.arn
}

# API Gateway
resource "aws_api_gateway_rest_api" "sqs_api" {
  name        = var.apigateway_name
  description = "API Gateway to send messages to SQS"
}

resource "aws_api_gateway_resource" "sqs_resource" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id
  parent_id   = aws_api_gateway_rest_api.sqs_api.root_resource_id
  path_part   = var.apigateway_path
}

resource "aws_api_gateway_method" "sqs_method" {
  rest_api_id   = aws_api_gateway_rest_api.sqs_api.id
  resource_id   = aws_api_gateway_resource.sqs_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sqs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sqs_api.id
  resource_id             = aws_api_gateway_resource.sqs_resource.id
  http_method             = aws_api_gateway_method.sqs_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:sqs:path/${var.aws_account_id}/${aws_sqs_queue.my_queue.name}"

  credentials = aws_iam_role.APIGateway-SQS-role.arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = <<EOF
Action=SendMessage&MessageBody=$input.body
EOF
  }
}

resource "aws_api_gateway_method_response" "sqs_method_response" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id
  resource_id = aws_api_gateway_resource.sqs_resource.id
  http_method = aws_api_gateway_method.sqs_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "sqs_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id
  resource_id = aws_api_gateway_resource.sqs_resource.id
  http_method = aws_api_gateway_method.sqs_method.http_method
  status_code = aws_api_gateway_method_response.sqs_method_response.status_code

  response_templates = {
    "application/json" = ""
  }
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "sqs_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id

  triggers = {
    # redeployment = sha1(jsonencode(aws_api_gateway_rest_api.sqs_api.body))
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.sqs_resource.id,
      aws_api_gateway_method.sqs_method.id,
      aws_api_gateway_integration.sqs_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Deployment environment
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.sqs_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sqs_api.id
  stage_name    = var.environment
  depends_on = [aws_cloudwatch_log_group.api_gateway_log_group]

  # Enable access logs for the stage
  access_log_settings {
    destination_arn = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/apigateway/${var.apigateway_name}"
    format          = "$context.requestId - $context.identity.sourceIp - $context.identity.userAgent"
  }

}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    data_trace_enabled = true
    logging_level   = "ERROR"
  }
}

resource "aws_api_gateway_method_settings" "path_specific" {
  rest_api_id = aws_api_gateway_rest_api.sqs_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "path1/GET"

  settings {
    metrics_enabled = true
    data_trace_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.sqs_api.id}/${var.environment}"
  retention_in_days = 7
  # ... potentially other configuration ...
}