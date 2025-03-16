# aws-serverless-1
API Gateway > SQS > Lambda 1 > DynamoDB > DynamoDB stream > Lambda 2 > SNS (send email)

![alt text](image.png)

# Test send message
curl -X POST -d '{"message": "Hello from API Gateway"}' \

     -H "Content-Type: application/json" \

     "https://your-api-id.execute-api.region.amazonaws.com/prod/POC-Queue"
