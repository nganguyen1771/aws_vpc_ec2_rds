### Introduction
This demo uses the cloudpose's library to build ec2 & rds in the vpc. the AWS structure is in AWS account that can be accessed via gateway account.
#### Get session token
Run command: ```get_token.sh```
#### Build structure
1. Run: ```terraform init```
2. Run ```terraform plan -var-file feature.tfvars```

