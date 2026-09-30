output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.demo.id
}

output "iam_role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.demo.arn
}

output "iam_policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.demo.arn
}
