## Enable the Cloudwtach logging and S3 logging for Session Manager Preferences ##

`We have enabled the AWS session manager by using aws ssm agent installtion and setup. Then, we requires prefrences i.e whoever logging to the session manager those logs and sessions to send the cloudwatch log group and s3 bucket for logging`.

# AWS Systemm Manager Documents 

An AWS Systems Manager document (SSM document) defines the actions that Systems Manager performs on your managed instances. Systems Manager includes more than 100 pre-configured documents that you can use by specifying parameters at runtime

`Reference Link`: https://docs.aws.amazon.com/systems-manager/latest/userguide/documents.html

1. IAM Permissions for Cloudwtach log Encryption
2. Create the CloudWatch log group to send the cloudwatch logs
3. Create the S3 bucket to send the session logs
4. Create the AWS SSM document 
5. Use the same document to configure the session manager preferences.

But unfortunatley there is no direct way to eanbel the session manager preferences, but tried using the null resource under `session-manager.tf` file it's not worked. So, Under AWS Systems Manager --> Session Manager --> preferences added `CloudWatch logging` and `S3 logging` manually. Remaining steps are configured by using terraform scripts.

6.  AWS Systems Manager --> Session Manager --> preferences --> edit select the cloudwatch log group hwt we have created by using terraform `/aws/ssm/session-manager/prod`, enable `Enforce CloudWatch log encryption`,  S3 logging select the s3 bucket name `nifi-prod-session-logs-758339324813` and enable the `enforce s3 log encryption`.