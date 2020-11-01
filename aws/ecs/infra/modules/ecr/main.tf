resource "aws_ecr_repository" "default" {
  name                 = var.project_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.project_tags, { type = "container" })
}

data "aws_ecr_image" "image_tags" {
  for_each = var.images

  repository_name = aws_ecr_repository.default

  image_tag = each.value
}
