
# # make s3 bucket for terraform state
terraform {
  backend "s3" {
    bucket         = "gettechie-s3-backend"
    key            = "eks-cluster"
    region         = "eu-west-2"
    dynamodb_table = "gettechie-eks-s3-lock"
  }
}

