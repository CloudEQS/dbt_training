from pyspark.sql.functions import current_timestamp, lit

def model(dbt, session):

    process_date = dbt.config.get("process_date")

    dbt.config(
        materialized="incremental",
        table_type="iceberg",
        incremental_strategy="append",
        tag="members_vendor" 
    )

    df = dbt.ref("mdl_s3")

    return (
        df
        .withColumn("process_date", lit(process_date))
        .withColumn("load_timestamp", current_timestamp())
    )