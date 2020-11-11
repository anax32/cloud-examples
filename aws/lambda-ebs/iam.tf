#
# permissions
#
data "aws_iam_policy" "lambda_vpc_execute" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "template_file" "lambda_efs_policy" {
  template = file("${path.module}/iam/lambda-efs.json.template")
  vars = {
    disk_arn = aws_efs_file_system.disk.arn
  }
}

resource "aws_iam_policy" "lambda_efs_read" {
  name   = "test_policy"
  policy = data.template_file.lambda_efs_policy.rendered
}

data "template_file" "lambda_s3_policy" {
  template = file("${path.module}/iam/lambda-s3.json.template")
  vars = {
    bucket_name = "models.bayis.co.uk"
  }
}

resource "aws_iam_policy" "lambda_s3_read" {
  name   = "read_s3_policy"
  policy = data.template_file.lambda_s3_policy.rendered
}

resource "aws_iam_role" "lt" {
  name               = "iam_for_lambda"
  assume_role_policy = file("${path.module}/iam/lambda.json.template")
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execute" {
  role       = aws_iam_role.lt.name
  policy_arn = data.aws_iam_policy.lambda_vpc_execute.arn
}

resource "aws_iam_role_policy_attachment" "lambda_efs_read" {
  role       = aws_iam_role.lt.name
  policy_arn = aws_iam_policy.lambda_efs_read.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read" {
  role       = aws_iam_role.lt.name
  policy_arn = aws_iam_policy.lambda_s3_read.arn
}
