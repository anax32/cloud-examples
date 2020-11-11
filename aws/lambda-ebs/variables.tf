variable "aws_access_key_id"     { type = string }
variable "aws_secret_access_key" { type = string }
variable "aws_region"            { type = string }

variable "project_name"          { type = string }

variable "aws_availability_zones" {
  type    = list(string)
  default = ["europe-west-2-a"]
}

variable "project_tags" {
  type = map
  default = {
    project = "lambda-ebs-example"
    source  = "github.com/anax32/cloud/aws"
    env     = "dev"
  }
}

variable "network_tags" {
  type = map
  default = {
    type = "network"
  }
}

variable "storage_tags" {
  type = map
  default = {
    type = "storage"
  }
}
