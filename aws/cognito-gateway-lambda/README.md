# AWS Example Cogntio Authenticate HTTP Gateway to Lambda Function

This example shows how to expose a lambda function via HTTP Gateway,
have that requests authenticated by a Cognito user-pool.

## Usage

clone the repo

```
# create a virtual env using python3
virtualenv -p python3 venv
source venv/bin/activate
pip install awscli

# run the terraform
terraform init
terraform plan -out new.plan
terraform apply new.plan
```

`CLIENT_ID` and test user info will be displayed as output.

These values can be used to run the `invoke-method.sh` script to test the function:
```bash
CLIENT_ID=<client-id> USERNAME=<username> PASSWORD=<password> ./invoke-gateway.sh
```

Hopefully you should see `Method completed with status: 200` on the last line of the output.

## Notes

+ user pool is called `my_users`
+ lambda function is called `my_function`
+ API is called `my_api`, with `my_resource`, `my_method`

The integration element connects the HTTP API Gateway with the Lambda backend,
it must perform a `POST` request to send the Gateway request to the Lambda function,
even if the Gateway method (and therefore the request) is `GET`, `PUT` etc.
The integration request is a separate issue from the Gateway request.

The Lambda function return value must be a dict/json document which matches a
protocol, see:
https://aws.amazon.com/premiumsupport/knowledge-center/malformed-502-api-gateway/

## Bonus points

+ list users in the user pool:
```bash

# assume 1 user pool
for user_pool_id in $(aws cognito-idp list-user-pools --max-results 10 | jq -r .UserPools[].Id)
do
  echo "user-pool-id: " ${user_pool_id}
  aws cognito-idp list-users --user-pool-id ${user_pool_id}
done
```

+ get OAuth tokens for a user:
```bash
aws cognito-idp \
  initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id ${CLIENT_ID} \
  --auth-parameters USERNAME=${USERNAME},PASSWORD=${PASSWORD}
```
