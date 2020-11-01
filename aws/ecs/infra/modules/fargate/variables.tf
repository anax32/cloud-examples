variable "project_name" { type = string }
variable "project_tags" { type = map(string) }
variable "network_tags" { type = map(string) }
variable "env"          { type = string }

variable "task_definitions" {
  type = map(object({
    fargate_cpu = number
    fargate_mem = number
    container_definitions = string
    task_tags = map(string)
  }))
}

variable "services" {
  type = map(object({
    lb_target_group_arn = string
    container_name = string
    container_port = number
    subnets = list(string)
    security_groups = list(string)
    public_ip = bool

    service_tags = map(string)
  }))
}

variable "vpc_id" { type = string }

variable "certificate_arn" { type = string }
