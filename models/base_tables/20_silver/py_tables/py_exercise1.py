import requests
import pandas as pd
from pyspark.sql.functions import current_timestamp, lit


def get_products(url, category_name):
    """
    Calls the REST API and returns a Pandas DataFrame
    with an additional category_name column.
    """

    response = requests.get(url, timeout=30)
    response.raise_for_status()

    products = response.json()["products"]

    pdf = pd.json_normalize(products)

    pdf["category_name"] = category_name

    return pdf


def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive"
    )

    api_list = [
        (
            "https://dummyjson.com/products/category/fragrances",
            "Fragrances"
        ),
        (
            "https://dummyjson.com/products/category/smartphones",
            "Smartphones"
        )
    ]

    all_dataframes = []

    for url, category in api_list:

        print(f"Calling API for {category}...")

        pdf = get_products(url, category)

        print(f"Fetched {len(pdf)} records.")

        all_dataframes.append(pdf)

    # Combine both DataFrames
    final_pdf = pd.concat(all_dataframes, ignore_index=True)

    # Convert numeric columns
    numeric_columns = [
        "price",
        "discountPercentage",
        "rating",
        "weight"
    ]

    for column in numeric_columns:
        if column in final_pdf.columns:
            final_pdf[column] = pd.to_numeric(
                final_pdf[column],
                errors="coerce"
            )

    # Create Spark DataFrame
    df = session.createDataFrame(final_pdf)

    # Add audit columns
    df = (
        df
        .withColumn("source_system", lit("DummyJSON"))
        .withColumn("load_timestamp", current_timestamp())
    )

    return df