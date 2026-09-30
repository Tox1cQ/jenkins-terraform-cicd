resource "aws_s3_bucket" "csv" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "Training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "csv" {
  bucket = aws_s3_bucket.csv.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "csv" {
  bucket = aws_s3_bucket.csv.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "csv" {
  bucket = aws_s3_bucket.csv.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
