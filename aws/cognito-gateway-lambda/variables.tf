variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_availability_zones" {
  type    = list(string)
  default = ["europe-west-2-a"]
}

variable "project_tags" {
  type = map
  default = {
    project = "cognito-gateway-lambda-example"
    source  = "github.com/anax32/cloud/aws"
  }
}

variable "test_users" {
  default = {
    "terraform-user-01" = {
      "password" = "tf-test-01"
      "email" = "tf-test-01@email.com"
    },
    "terraform-user-02" = {
      "password" = "tf-test-02"
      "email" = "tf-test-02@email.com"
    }
  }
}

