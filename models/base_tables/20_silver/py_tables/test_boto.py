import boto3
import json
import requests

def get_secret():
    client = boto3.client("secretsmanager", region_name="us-east-2") 

    secret = client.get_secret_value(
        SecretId="SaleasforceAPI"
    )
    return json.loads(secret["SecretString"])

def model(dbt, session):
    dbt.config(
        materialized="table",
        table_type="hive"
    )

    creds = get_secret()
    print(creds)
    
    headers = {
        "Authorization": f"Bearer {creds['username']}"
    }
    response = ""
    data = response.json()
    return session.createDataFrame(data)