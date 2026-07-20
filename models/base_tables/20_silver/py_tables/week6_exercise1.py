from pyspark.sql.functions import (
    current_timestamp,
    input_file_name,
    regexp_extract,
    lower,
    col,
    row_number
)

from pyspark.sql.window import Window

def model(dbt, session):

    dbt.config(
        materialized="table",
        table_type="hive"
    )

    folder = "s3://dbt-training-datalake-336136505312-us-east-2-an/files/members/"

    print(f"Reading files from : {folder}")

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

    df = df.withColumn(
        "load_timestamp",
        current_timestamp()
    )

    # Rename all columns to lowercase

    for c in df.columns:
        df = df.withColumnRenamed(c, c.lower())

    # Remove duplicates using Window specification

    window_spec = (
        Window
        .partitionBy("member_id")
        .orderBy(col("effective_date").desc())
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