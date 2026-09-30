resource "aws_iam_role" "demo" {
  name = "${var.project_name}-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = "Training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "demo" {
  name        = "${var.project_name}-s3-policy"
  description = "Allow limited access to the training S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.demo.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.demo.arn}/*"
      }
    ]
  })

  tags = {
    Environment = "Training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "demo" {
  role       = aws_iam_role.demo.name
  policy_arn = aws_iam_policy.demo.arn
}
