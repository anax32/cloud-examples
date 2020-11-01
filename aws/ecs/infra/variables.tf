variable "aws_access_key_id"     { type = string }
variable "aws_secret_access_key" { type = string }
variable "aws_region"            { type = string }

variable "project_name"   { type = string }
variable "project_domain" { type = string }
variable "env"            { type = string }

variable "project_tags" {
  type = map
  default = {
    project = "anax32/gists/ecs-demo"
    mode    = "infrastructure"
    env     = "dev"
  }
}

variable "network_tags" {
  type = map(string)
  default = {
    type = "network"
  }
}

variable "container_tags" {
  type = map(string)
  default = {
    type = "container"
  }
}
