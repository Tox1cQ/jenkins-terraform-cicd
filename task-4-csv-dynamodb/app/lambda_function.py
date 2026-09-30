import csv
import io
import json
import logging
import os
from decimal import Decimal
from urllib.parse import unquote_plus

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = os.environ["DYNAMODB_TABLE"]
table = dynamodb.Table(TABLE_NAME)


def convert_value(value):
    """Convert numeric CSV values to DynamoDB-compatible numbers."""
    value = value.strip()

    if value == "":
        return None

    try:
        return Decimal(value)
    except Exception:
        return value


def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    try:
        # Support EventBridge S3 events and direct test events.
        if "detail" in event:
            bucket = event["detail"]["bucket"]["name"]
            key = unquote_plus(event["detail"]["object"]["key"])
        else:
            bucket = event["bucket"]
            key = unquote_plus(event["key"])

        logger.info("Reading CSV from s3://%s/%s", bucket, key)

        response = s3.get_object(Bucket=bucket, Key=key)
        content = response["Body"].read().decode("utf-8-sig")

        reader = csv.DictReader(io.StringIO(content))
        if not reader.fieldnames or "id" not in reader.fieldnames:
            raise ValueError("CSV must contain an 'id' column.")

        inserted_count = 0

        with table.batch_writer(overwrite_by_pkeys=["id"]) as batch:
            for row in reader:
                if not row.get("id", "").strip():
                    raise ValueError("Every CSV record must have a non-empty id.")

                item = {}
                for field, value in row.items():
                    if field is None:
                        continue

                    converted = convert_value(value or "")
                    if converted is not None:
                        item[field] = converted

                batch.put_item(Item=item)
                inserted_count += 1

        logger.info(
            "Successfully processed %s records from s3://%s/%s",
            inserted_count,
            bucket,
            key,
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "CSV processed successfully",
                "records_processed": inserted_count,
                "bucket": bucket,
                "key": key,
            }),
        }

    except Exception:
        logge
