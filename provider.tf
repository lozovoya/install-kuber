provider "aws" {
region = var.AWS_REGION
profile = "terraform"
shared_credentials_files = ["~/.aws/credentials"]
}
