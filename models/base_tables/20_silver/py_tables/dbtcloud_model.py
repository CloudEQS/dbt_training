import boto3
import json
import requests
import pandas as pd
from datetime import datetime, timedelta
import logging
from pyspark.sql.types import StructType
from pyspark.sql.types import NullType, StringType, ArrayType
from pyspark.sql import functions as F

logger = logging.getLogger('failed_dbt_logger')

ACCOUNT_ID = 179022
LIMIT = 100

def get_secret():
    client = boto3.client("secretsmanager", region_name="us-east-2") 
    secret = client.get_secret_value(
        SecretId="cloudeqs_lab_credentials"
    )
    return json.loads(secret["SecretString"])

def call_api(status, time_input_start, time_input_end, headers):
    all_runs = []
    offset = 0
    while True:
        params = {
            "limit": LIMIT,
            "offset": offset,
            "status": status
        }
        url = f"https://cloud.getdbt.com/api/v2/accounts/{ACCOUNT_ID}/runs?finished_at__range=['{time_input_start}','{time_input_end}']"
        resp = requests.request('GET', url=url, headers=headers, params=params, verify=False)
        data = resp.json()
        all_runs.extend(data.get('data', []))
        if len(data.get("data", [])) < LIMIT:
            break
        offset += LIMIT
    df = pd.DataFrame(all_runs)
    if not df.empty:
        df["dbt_last_refreshed_timestamp"] = datetime.now()
    return df

def model(dbt, session):
    dbt.config(
        materialized="incremental",
        unique_key=["id"],
    )
    creds = get_secret()
    headers = {
        "Authorization": f"Bearer {creds['cx_dbt_api_token']}"
    }
    time_input_start = (datetime.now().replace(hour=0, minute=0, second=0) - timedelta(days=1)).strftime('%Y-%m-%d %H:%M:%S')
    time_input_end = datetime.now().replace(hour=0, minute=0, second=0).strftime('%Y-%m-%d %H:%M:%S')

    df_result = call_api(status=20, time_input_start=time_input_start, time_input_end=time_input_end, headers=headers)
    
    if df_result.empty:
        return session.createDataFrame([], StructType([]))
    spark_df = session.createDataFrame(df_result)
    spark_df = spark_df.toDF(*[c.upper() for c in spark_df.columns])
    # spark_df = spark_df.filter(spark_df.ENVIRONMENT_ID.isin(ENVIRONMENT_IDS))

    for field in spark_df.schema.fields:
        if isinstance(field.dataType, NullType):
            spark_df = spark_df.withColumn(field.name, F.col(field.name).cast(StringType()))
        elif isinstance(field.dataType, ArrayType) and isinstance(field.dataType.elementType, NullType):
            spark_df = spark_df.withColumn(field.name, F.col(field.name).cast(ArrayType(StringType())))
    return spark_df