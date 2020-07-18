import os
import json

def handler(event, context):
  """
  simple handler to return the environment variables inside the lambda function
  NB: this dict/json structure MUST be returned by any lambda functions which
      respond to an API Gateway
  """
  return {
    "statusCode": "200",
    "headers": { "content-type": "application/json" },
    "body": json.dumps({k: v for k, v in os.environ.items()})
  }
