def model(dbt, session):
    dbt.config(materialized="table", table_type="hive")

    data = [
        (1, "Alice", 500.0),
        (2, "Bob", 300.0),
        (3, "Carol", 750.0),
        (4, "Carol", 222.0),
    ]

    df = session.createDataFrame(data, ["customer_id", "name", "total_amount"])
    return df
