import boto3
import json
import requests

def get_secret():

    client = boto3.client("secretsmanager")

    secret = client.get_secret_value(
        SecretId="prod/customer-api"
    )

    return json.loads(secret["SecretString"])


def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive"
    )

    creds = get_secret()

    headers = {
        "Authorization": f"Bearer {creds['token']}"
    }

    response = requests.get(
        creds["url"],
        headers=headers
    )

    data = response.json()

    return session.createDataFrame(data)