export BUCKET_ID="jj-ops-gif"

# Create a S3 Bucket for Terraform state
aws s3api create-bucket --bucket terraform-state-bucket-$BUCKET_ID --region us-east-1
aws s3api put-bucket-versioning --bucket terraform-state-bucket-$BUCKET_ID --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket terraform-state-bucket-$BUCKET_ID --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Create a DynamoDB Table for Terraform state
aws dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1
