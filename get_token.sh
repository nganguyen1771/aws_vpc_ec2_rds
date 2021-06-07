#!/bin/bash
tokens=$(aws sts --profile te-dev-admin assume-role --role-arn "arn:aws:iam::<deploy_account>:role/infras_admin" --role-session-name "infras_admin")
secret=$(echo -- "$tokens" | sed -n 's!.*"SecretAccessKey": "\(.*\)".*!\1!p')
session=$(echo -- "$tokens" | sed -n 's!.*"SessionToken": "\(.*\)".*!\1!p')
access=$(echo -- "$tokens" | sed -n 's!.*"AccessKeyId": "\(.*\)".*!\1!p')
echo "[default]" > ~/.aws/session_token
echo "aws_access_key_id=${access}" >> ~/.aws/session_token
echo "aws_secret_access_key=${secret}" >> ~/.aws/session_token
echo "aws_session_token=${session}" >> ~/.aws/session_token
