from pyspark.sql.functions import (
    current_timestamp,
    input_file_name,
    regexp_extract,
    lower,
    col,
    row_number,
    to_timestamp,
    count
)
from pyspark.sql.types import (
    StructType,
    StructField,
    StringType,
    IntegerType,
    LongType,
    DoubleType,
    TimestampType
)
from pyspark.sql.window import Window

def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive",
        tags=['claims_mdl']
    )

    folder = "s3://dbt-training-datalake-336136505312-us-east-2-an/files/claims/data/"

    print(f"Reading files from : {folder}")

    files = (
        session.read
        .format("binaryFile")
        .load(folder)
    )

    if files.count() == 0:
        print("No files found.")
        schema = StructType([
            StructField("claim_id", StringType(), True),
            StructField("patient_id", StringType(), True),
            StructField("claim_amount", StringType(), True),
            StructField("status", StringType(), True),
            StructField("last_modified_date", StringType(), True),
            StructField("file_name", StringType(), True),            
            StructField("process_date", TimestampType(), True),
            StructField("load_timestamp", TimestampType(), True)
        ])

        return session.createDataFrame([], schema)    

    df = (
        session.read
        .option("header", "true")
        .csv(folder)
    )

    # Add file name

    df = df.withColumn(
        "file_name",
        input_file_name()
    )

    # Extract process date from filename

    df = df.withColumn(
        "process_date",
        regexp_extract(
            col("file_name"),
            r"(\d{8})",
            1
        )
    )

    # Add load timestamp

   
    df = (df
            .withColumn("last_modified_date",  to_timestamp("last_modified_date", "yyyy-MM-dd"))
            .withColumn("load_timestamp", current_timestamp())
            .withColumn("claim_amount",col("claim_amount").cast("double"))

    )

    # Rename all columns to lowercase

    for c in df.columns:
        df = df.withColumnRenamed(c, c.lower())


    log_df = (
        df.groupBy("file_name", "process_date")
        .agg(count("*").alias("row_count"))
        .withColumn("load_timestamp", current_timestamp())
    )


    (
        log_df.write
          .mode("append")
          .insertInto("dbt_training.file_load_log")
    )
    # Remove duplicates using Window specification

    window_spec = (
        Window
        .partitionBy("claim_id")
        .orderBy(col("last_modified_date").desc())
    )

    # Keep latest record

    df = (
        df.withColumn("rn", row_number().over(window_spec))
          .filter(col("rn") == 1)
          .drop("rn")
    )


    df = df.dropDuplicates()

    print(f"Rows Loaded : {df.count()}")

    return df