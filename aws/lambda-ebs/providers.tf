provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.aws_region
  version    = "> 2.31.0"
}

provider "archive" {
  version = "> 1.2"
}
