#
# source
#
data "archive_file" "env_print_source" {
  type        = "zip"
  source_dir  = "${path.module}/lambdas/env-print/"
  output_path = ".out/print-env.zip"
}

#
# functions
#
resource "aws_lambda_function" "print_env" {
  filename         = data.archive_file.env_print_source.output_path
  function_name    = "print_env"
  role             = aws_iam_role.lt.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.env_print_source.output_base64sha256

  runtime = "python3.7"

  environment {
    variables = {
      foo = "bar"
    }
  }

  # disk
  file_system_config {
    arn              = aws_efs_access_point.disk_write.arn
    local_mount_path = "/mnt/efs"
  }

  # vpc
  vpc_config {
    subnet_ids         = module.vpc.intra_subnets
    security_group_ids = [module.lambda_efs_sg.this_security_group_id]
  }

  tags = merge(var.project_tags)
}
