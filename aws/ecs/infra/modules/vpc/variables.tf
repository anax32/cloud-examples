variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "project_tags" {
  type = map(string)
}

variable "network_tags" {
  type = map(string)
}
