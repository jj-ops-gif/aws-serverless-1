terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-jj-ops-gif"
    key            = "aws-serverless-1/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
