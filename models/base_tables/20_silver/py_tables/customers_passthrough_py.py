def model(dbt, session):
    dbt.config(materialized="table", table_type="hive")

    df = dbt.ref("stg_customers_py")
    return df
