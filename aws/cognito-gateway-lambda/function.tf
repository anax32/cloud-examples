variable "lambda_tags" {
  default = {
    component = "lambda"
  }
}

#
# iam
#
resource "aws_iam_role" "my_function" {
  assume_role_policy = file("./iam/lambda_iam.json.template")
}

#
# source
#
data "archive_file" "my_function_source" {
  type        = "zip"
  source_dir  = "${path.module}/functions/my-function"
  output_path = "${path.module}/.out/my-function-source.zip"
}

#
# functions
#
resource "aws_lambda_function" "my_function" {
  filename         = data.archive_file.my_function_source.output_path
  function_name    = "my_function"
  role             = aws_iam_role.my_function.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.my_function_source.output_base64sha256

  runtime = "python3.7"

  tags = merge(
    var.project_tags,
    var.lambda_tags
  )
}
