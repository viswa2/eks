variable "environment" {
  description = "Environment name (e.g., prod)"
  type        = string
}

variable "instance_id" {
  description = "Target EC2 instance ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}