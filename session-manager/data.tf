# Get current AWS account ID and Region and existing role by using Data source
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_role" "existing_role" {
  name = "AmazonSSMandCloudwatchAgentServerRole"
}
