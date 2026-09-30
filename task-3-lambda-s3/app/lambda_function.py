import boto3
import csv
import io
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")


def lambda_handler(event, context):
    try:
        bucket = event.get("bucket") or os.environ.get("BUCKET_NAME")
        key = event.get("key")

        if not bucket or not key:
            raise ValueError("Both bucket and key are required.")

        logger.info("Starting CSV processing")
        logger.info("Bucket: %s", bucket)
        logger.info("File: %s", key)

        response = s3.get_object(Bucket=bucket, Key=key)
        content = response["Body"].read().decode("utf-8-sig")

        reader = csv.DictReader(io.StringIO(content))

        if not reader.fieldnames:
            raise ValueError("CSV file is empty or has no header.")

        logger.info("CSV columns: %s", reader.fieldnames)

        row_count = 0

        for row_count, row in enumerate(reader, start=1):
            logger.info("Row %d: %s", row_count, json.dumps(row))

        logger.info("CSV processing completed. Rows: %d", row_count)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "CSV processed successfully",
                "bucket": bucket,
                "key": key,
                "rows_processed": row_count
            })
        }

    except Exception:
        logger.exception("CSV processing failed")
        raise
