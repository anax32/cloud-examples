variable "userpool_tags" {
  default = {
    component = "userpool"
  }
}

#
# user pool
#
resource "aws_cognito_user_pool" "my_users" {
  name = "my_user_pool"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  auto_verified_attributes = ["email"]
  mfa_configuration = "OFF"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  tags = merge(
    var.project_tags,
    var.userpool_tags
  )
}

#
# client application ID
#   use this ID to connect applications to the user pool
#
resource "aws_cognito_user_pool_client" "my_application" {
  name = "my_application"
  user_pool_id = aws_cognito_user_pool.my_users.id
  generate_secret     = false
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

#
# this variable is the client-id we need in
# some user-facing application code.
#
output "application_client_id" {
  value = aws_cognito_user_pool_client.my_application.id
}
