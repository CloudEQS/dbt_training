import requests


def model(dbt, session):

    dbt.config(
        materialized="table"     
    )

    # Call REST API
    response = requests.get(
        "https://jsonplaceholder.typicode.com/users",
        timeout=30
    )

    response.raise_for_status()

    users = response.json()

    # Convert JSON to Spark DataFrame
    df = session.createDataFrame(users)

    return df