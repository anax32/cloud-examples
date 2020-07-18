#/bin/bash -u

if [ -z $CLIENT_ID ]
then
  echo "CLIENT_ID environment variable must be set"
  exit -1
fi

if [ -z $USERNAME ]
then
  echo "USERNAME environment variable must be set"
  exit -1
fi

if [ -z $PASSWORD ]
then
  echo "PASSWORD environment variable must be set"
  exit -1
fi

API_ID=$(aws apigateway \
            get-rest-apis \
            | jq -r .items[0].id)

echo "api-id: " $API_ID

AUTH_ID=$(aws apigateway \
            get-authorizers \
            --rest-api-id ${API_ID} \
            | jq -r .items[0].id)

echo "authorizer-id: " $AUTH_ID

ID_TOKEN=$(aws cognito-idp \
             initiate-auth \
             --auth-flow USER_PASSWORD_AUTH \
             --auth-parameters=USERNAME=${USERNAME},PASSWORD=${PASSWORD} \
             --client-id ${CLIENT_ID} \
             | jq -r .AuthenticationResult.IdToken)

echo "oauth-token-id: " $ID_TOKEN

# test the authorizer
aws apigateway \
  test-invoke-authorizer \
  --rest-api-id ${API_ID} \
  --authorizer-id ${AUTH_ID} \
  --header Authorization=${ID_TOKEN}

# test the method

# get the id of the resource for "my-resource"
RESOURCE_ID=$(aws apigateway \
                get-resources \
                --rest-api-id ${API_ID} \
                | jq -r '.items[] | select(.pathPart == "my-resource").id')

echo "resource-id: " ${RESOURCE_ID}

aws apigateway \
  test-invoke-method \
  --rest-api ${API_ID} \
  --resource-id ${RESOURCE_ID} \
  --http-method GET \
  --path-with-query-string '/my-resource' \
  --header Authorization=${ID_TOKEN} \
  | jq -r '.log | .'
