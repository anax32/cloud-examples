resource "aws_ecs_cluster" "fargate" {
  name = var.project_name
  capacity_providers = ["FARGATE_SPOT"]

  tags = merge(var.project_tags)
}

resource "aws_cloudwatch_log_group" "fargate" {
  name              = var.project_name
  retention_in_days = 5
}
