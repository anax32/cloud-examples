resource "aws_ecs_task_definition" "default" {
  for_each = var.task_definitions

  family = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  cpu = each.value.fargate_cpu
  memory = each.value.fargate_mem

  container_definitions = each.value.container_definitions

  # https://github.com/cloudposse/terraform-aws-ecs-alb-service-task/issues/39
  tags = merge(var.project_tags, each.value.task_tags)
}
