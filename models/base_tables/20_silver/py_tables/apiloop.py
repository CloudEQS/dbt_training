import requests
import pandas as pd
from pyspark.sql.functions import current_timestamp, lit


def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive"
    )

    limit = 100
    skip = 0

    all_posts = []

    while True:

        url = f"https://dummyjson.com/posts?limit={limit}&skip={skip}"

        response = requests.get(url, timeout=30)
        response.raise_for_status()

        result = response.json()

        posts = result["posts"]

        if len(posts) == 0:
            break

        all_posts.extend(posts)

        print(f"Fetched {len(posts)} records")

        skip += limit

        if skip >= result["total"]:
            break

    # Convert JSON list to Pandas DataFrame
    pdf = pd.DataFrame(all_posts)

    # Convert Pandas to Spark DataFrame
    df = session.createDataFrame(pdf)

    # Add audit columns
    df = (
        df
        .withColumn("source_system", lit("DummyJSON"))
        .withColumn("load_timestamp", current_timestamp())
    )

    return df