resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}"
  retention_in_days = 14

  tags = {
    Environment = "Training"
    ManagedBy   = "Terraform"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../app/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "csv_processor" {
  function_name = var.project_name
  role          = aws_iam_role.lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  timeout     = 60
  memory_size = 128

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.csv.id
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda,
    aws_cloudwatch_log_group.lambda
  ]

  tags = {
    Environment = "Training"
    ManagedBy   = "Terraform"
  }
}
