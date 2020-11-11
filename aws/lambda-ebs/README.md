# AWS Example Lambda Function with EBS

This example shows how to create a lambda function with elastic block storage attached.

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
