def model(dbt, session):
    dbt.config(materialized="table", table_type="hive")

    customers = dbt.ref("stg_customers_py")
    orders = dbt.ref("stg_orders_py")

    joined = customers.join(orders, "customer_id", "left")
    return joined
