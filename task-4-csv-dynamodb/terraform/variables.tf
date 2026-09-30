variable "aws_region" {
  description = "AWS region for Task 4"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used to identify AWS resources"
  type        = string
  default     = "tushar-task4-csv-dynamodb"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda memory in MB"
  type        = number
  default     = 256
}
