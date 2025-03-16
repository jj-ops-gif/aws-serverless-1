import os, boto3, json

# Get SNS Topic ARN from environment variable
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

client = boto3.client('sns')

def lambda_handler(event, context):

    for record in event["Records"]:

        if record['eventName'] == 'INSERT':
            new_record = record['dynamodb']['NewImage']    
            response = client.publish(
                TargetArn=SNS_TOPIC_ARN,
                Message=json.dumps({'default': json.dumps(new_record)}),
                MessageStructure='json'
            )