### Introduction
This demo uses the cloudpose's library to build ec2 & rds in the vpc. The AWS structure is in AWS account that accessed via gateway account.
#### Get session token
Run command: ```get_token.sh```
#### Build structure
1. Run: ```terraform init```
2. Run ```terraform plan -var-file feature.tfvars```

