#
# create some test users to make integration
# testing a little easier.
#
resource "null_resource" "create_test_users" {
  for_each = var.test_users

  # this command does sign-up and force confirm for a user
  provisioner "local-exec" {
    command = <<-EOF
      aws cognito-idp sign-up --client-id ${aws_cognito_user_pool_client.my_application.id} --username ${each.key} --password ${each.value["password"]} --user-attributes=Name=email,Value=${each.value["email"]}
      aws cognito-idp admin-set-user-password --user-pool-id ${aws_cognito_user_pool.my_users.id} --username ${each.key} --password ${each.value["password"]} --permanent
    EOF

    interpreter = ["bash", "-c"]

    environment = {
      AWS_ACCESS_KEY = var.aws_access_key_id
      AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
      AWS_DEFAULT_REGION = var.aws_region
      CLIENT_ID = aws_cognito_user_pool_client.my_application.id
      POOL_ID = aws_cognito_user_pool.my_users.id
    }
  }

  depends_on = [
    aws_cognito_user_pool.my_users,
    aws_cognito_user_pool_client.my_application
  ]
}

output "user-info" {
  value = {
    for user, info in var.test_users:
      user => info.password
  }
}
