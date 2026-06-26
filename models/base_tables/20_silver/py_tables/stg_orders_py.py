def model(dbt, session):
    dbt.config(materialized="table", table_type="hive")

    data = [
        (1, "2026-01-10", 2),
        (2, "2026-01-12", 1),
        (3, "2026-01-15", 5),
        (4, "2026-01-18", 3),
    ]

    df = session.createDataFrame(data, ["customer_id", "order_date", "order_count"])
    return df
