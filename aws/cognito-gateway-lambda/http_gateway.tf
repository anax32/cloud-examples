variable gateway_tags {
  default = {
    component = "http-gateway"
  }
}

#
# + create the REST API
# + connect the Cognito user pool as an authorizer
# + connect the lambda function as an integration
#
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my_api"
  description = "my incredible api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  binary_media_types = [
    "application/octet"
  ]

  tags = merge(
    var.project_tags,
    var.gateway_tags
  )
}


resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "my-resource"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.my_users.id
}

resource "aws_api_gateway_integration" "my_method" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_resource.id
  http_method = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.my_function.invoke_arn
}

#
# connect the cognito user pool as an authorizer
#
resource "aws_api_gateway_authorizer" "my_users" {
  name          = "cognito"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  provider_arns = [aws_cognito_user_pool.my_users.arn]
}

#
# lambda execute permission
#
resource "aws_lambda_permission" "my_function" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_function.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/${aws_api_gateway_method.my_method.http_method}${aws_api_gateway_resource.my_resource.path}"
}

