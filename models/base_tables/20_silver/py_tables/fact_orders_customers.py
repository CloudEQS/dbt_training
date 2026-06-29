from pyspark.sql import functions as F
from pyspark.sql.window import Window


def model(dbt, session):
    dbt.config(materialized="table", table_type="hive")

    # parallelism hint - matches executor cores
    session.conf.set("spark.sql.shuffle.partitions", "8")

    orders = dbt.ref("stg_orders_py").repartition(8, "customer_id")

    # dummy customer dim
    customers_data = [
        (1, "Alice", "APAC", "2024-03-01", "GOLD"),
        (2, "Bob", "EMEA", "2023-11-15", "SILVER"),
        (3, "Charlie", "NA", "2022-07-20", "GOLD"),
        (4, "Diana", "APAC", "2025-01-05", "BRONZE"),
    ]
    customers = session.createDataFrame(
        customers_data, ["customer_id", "name", "region", "signup_date", "tier"]
    ).repartition(8, "customer_id")

    # dummy order line items keyed by customer_id (stg_orders_py has no order_id)
    items_data = [
        (1, "Laptop", "Electronics", 1200.0, 1),
        (1, "Mouse", "Electronics", 25.0, 2),
        (2, "Chair", "Furniture", 150.0, 1),
        (3, "Phone", "Electronics", 800.0, 1),
        (3, "Desk", "Furniture", 300.0, 1),
        (4, "Notebook", "Stationery", 5.0, 10),
    ]
    items = session.createDataFrame(
        items_data, ["customer_id", "product", "category", "price", "qty"]
    ).repartition(8, "customer_id")

    items = items.withColumn("line_total", F.col("price") * F.col("qty"))

    # aggregate items per customer (distributed groupBy)
    items_agg = items.groupBy("customer_id").agg(
        F.sum("line_total").alias("order_value"),
        F.count("*").alias("line_item_count"),
    )

    # category spend pivot (wide table, parallel across categories)
    category_pivot = (
        items.groupBy("customer_id")
        .pivot("category")
        .agg(F.sum("line_total"))
        .na.fill(0)
    )

    # join everything
    joined = (
        orders.join(items_agg, "customer_id", "left")
        .join(category_pivot, "customer_id", "left")
        .join(customers, "customer_id", "left")
    )

    joined = joined.withColumn("order_date", F.to_date("order_date")) \
        .withColumn("signup_date", F.to_date("signup_date"))

    joined = joined.withColumn(
        "days_since_signup", F.datediff("order_date", "signup_date")
    )

    # window functions - parallel per customer partition
    cust_window = Window.partitionBy("customer_id").orderBy("order_date")

    joined = joined.withColumn(
        "running_total_value",
        F.sum("order_value").over(cust_window),
    ).withColumn(
        "order_rank",
        F.rank().over(cust_window),
    ).withColumn(
        "prev_order_value",
        F.lag("order_value").over(cust_window),
    )

    # conditional tiering on order value
    joined = joined.withColumn(
        "value_segment",
        F.when(F.col("order_value") >= 1000, "HIGH")
        .when(F.col("order_value") >= 200, "MEDIUM")
        .otherwise("LOW"),
    )

    # customer-level summary via window (broadcast-friendly)
    cust_total_window = Window.partitionBy("customer_id")
    joined = joined.withColumn(
        "customer_lifetime_value",
        F.sum("order_value").over(cust_total_window),
    ).withColumn(
        "customer_order_count",
        F.count("order_date").over(cust_total_window),
    )

    result = joined.select(
        "customer_id", "name", "region", "tier",
        "order_date", "order_value", "line_item_count",
        "days_since_signup", "running_total_value", "order_rank",
        "prev_order_value", "value_segment",
        "customer_lifetime_value", "customer_order_count",
        *[c for c in category_pivot.columns if c != "customer_id"],
    ).repartition(8, "customer_id")

    return result
