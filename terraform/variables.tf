variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for the project resources"
  type        = string
  default     = "jenkins-terraform-demo"
}
