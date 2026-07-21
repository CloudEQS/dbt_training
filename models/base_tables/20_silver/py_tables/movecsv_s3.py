import boto3
from pyspark.sql.functions import (
    current_timestamp,
    input_file_name,
    regexp_extract,
    lit    
)

from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    IntegerType,
    LongType,
    DoubleType,
    TimestampType
)

def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive",
        tags=["claims_mdl"]
    )

    # Ensure claims.sql finishes first
    dbt.ref("false_model")

    BUCKET = "dbt-training-datalake-336136505312-us-east-2-an"

    SOURCE_PREFIX = "files/claims/data/"
    ARCHIVE_PREFIX = "files/claims/processed/"
    
    s3 = boto3.client("s3")

    # Get all CSV files
    response = s3.list_objects_v2(
        Bucket=BUCKET,
        Prefix=SOURCE_PREFIX
    )

    files = []

    for obj in response.get("Contents", []):

        key = obj["Key"]

        if key.endswith(".csv"):
            files.append(f"s3://{BUCKET}/{key}")

    if not files:
        raise Exception("No CSV files found.")

    # Move files after processing
    for file in files:

        key = file.replace(f"s3://{BUCKET}/", "")

        archive_key = key.replace(
            SOURCE_PREFIX,
            ARCHIVE_PREFIX,
            1
        )

        # Copy
        s3.copy_object(
            Bucket=BUCKET,
            CopySource={
                "Bucket": BUCKET,
                "Key": key
            },
            Key=archive_key
        )

        # Delete original
        s3.delete_object(
            Bucket=BUCKET,
            Key=key
        )


    schema = StructType([
        StructField("status", StringType(), True),
        StructField("run_time", TimestampType(), True)
    ])

    return session.createDataFrame([], schema)    