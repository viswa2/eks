# Session Manager Document
resource "aws_ssm_document" "session_manager_prefs" {
  name          = "SSM-SessionManagerRunShell-${var.instance_id}" # Added environment to make it unique
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document for Session Manager-${var.instance_id}"
    sessionType   = "Standard_Stream"
    parameters = {
      enableLogging = {
        type    = "String",
        default = "true"
      },
      cloudWatchLogGroupName = {
        type    = "String",
        default = aws_cloudwatch_log_group.session_logs.name
      },
      s3BucketName = {
        type    = "String",
        default = aws_s3_bucket.session_logs.bucket
      },
      s3EncryptionEnabled = {
        type    = "String",
        default = "true"
      },
      s3KeyPrefix = {
        type    = "String",
        default = "session-logs/"
      },
      cloudWatchEncryptionEnabled = {
        type    = "String",
        default = "true"
      },
      cloudWatchStreamingEnabled = {
        type    = "String"
        default = "true"
      }
    }
  })
}

# Note: Session Manager Preferences (CloudWatch and S3 logging) were enabled manually in AWS Console
# AWS Systems Manager -> Session Manager -> Preferences
# The following null_resource was not working as expected and is kept for reference
/*
resource "null_resource" "enable_session_manager_preferences" {
  provisioner "local-exec" {
    command = <<EOT
      aws ssm update-document-default-version \
        --name "${aws_ssm_document.session_manager_prefs.name}" \
        --document-version "1"
    EOT
  }
  depends_on = [
    aws_ssm_document.session_manager_prefs,
    aws_s3_bucket.session_logs,
    aws_cloudwatch_log_group.session_logs
  ]
}
*/
