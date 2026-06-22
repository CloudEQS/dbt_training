def model(dbt, session):
    dbt.config(
        materialized="table",
        table_type="iceberg",
        spark_work_group="dbt_spark_workgroup",
        location="s3://dbt-training-datalake-336136505312-us-east-2-an/iceberg-tables/python_model/",
        engine_config={
            "CoordinatorDpuSize": 1,
            "MaxConcurrentDpus": 2,
            "DefaultExecutorDpuSize": 1,
            "SparkProperties": {},
        },
    )
 
    data = [
        (1, "Alice", 500.0),
        (2, "Bob", 300.0),
        (3, "Carol", 750.0),
        (4, "Carol", 222.0),
    ]
 
    df = session.createDataFrame(data, ["customer_id", "name", "total_amount"])
 
    return df 