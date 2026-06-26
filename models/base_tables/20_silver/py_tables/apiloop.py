import requests


def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive"
    )

    limit = 100
    skip = 0

    all_products = []

    while True:

        url = f"https://dummyjson.com/products?limit={limit}&skip={skip}"

        response = requests.get(url, timeout=30)
        response.raise_for_status()

        result = response.json()

        products = result["products"]

        if not products:
            break

        all_products.extend(products)

        print(f"Fetched {len(products)} records (skip={skip})")

        skip += limit

        if skip >= result["total"]:
            break

    df = session.createDataFrame(all_products)

    return df