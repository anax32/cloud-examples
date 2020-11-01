output "url" {
  value = aws_ecr_repository.repository_url
}

output "id" {
  value = aws_ecr_repository.registry_id
}

output "images" {
  value = data.aws_ecr_image[*].id
}
