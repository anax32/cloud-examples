resource "aws_ecs_service" "default" {
  for_each = var.services

  name            = each.key
  cluster         = aws_ecs_cluster.fargate.id
#  task_definition = aws_ecs_task_definition.default.arn
  launch_type     = "FARGATE"

  desired_count = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets = each.value.subnets
    security_groups = each.value.security_groups
    assign_public_ip = each.value.public_ip
  }

  load_balancer {
    target_group_arn = each.value.lb_target_group_arn
    container_name = each.value.container_name
    container_port = each.value.container_port
  }

  enable_ecs_managed_tags = true
  propagate_tags = "SERVICE"
  tags = merge(var.project_tags, each.value.service_tags)
}
