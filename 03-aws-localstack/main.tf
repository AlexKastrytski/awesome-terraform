provider "aws" {
  access_key                  = "local"
  secret_key                  = "local"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    dynamodb       = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
  }
}

#terraform {
 # backend "s3" {
 #   bucket                      = "tf-state"
 #   key                         = "terraform.tfstate"
 #  region                      = "us-east-1"
 #  endpoint                    = "http://s3.localhost.localstack.cloud:4566"
 #  skip_credentials_validation = true
 #  skip_metadata_api_check     = true
 #  force_path_style            = true
 #   dynamodb_table              = "terraform-lock"
 #   dynamodb_endpoint           = "http://localhost:4566"
 #  encrypt                     = true
 # }
#}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tf-state"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
    name           = "terraform-lock"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}

#resource "aws_s3_bucket" "main_bucket" {
# bucket = "main-bucket"
#}

