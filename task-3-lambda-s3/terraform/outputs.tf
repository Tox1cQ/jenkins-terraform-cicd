output "s3_bucket_name" {
  description = "S3 bucket for CSV files"
  value       = aws_s3_bucket.csv.id
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.csv_processor.function_name
}

output "lambda_role_arn" {
  description = "Lambda execution role ARN"
  value       = aws_iam_role.lambda.arn
}

output "cloudwatch_log_group" {
  description = "Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda.name
}
