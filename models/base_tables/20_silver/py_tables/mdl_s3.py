from datetime import datetime
from pyspark.sql.functions import current_timestamp

def model(dbt, session):

    dbt.config(
        tag="members_vendor"        
     )

    today = datetime.now().strftime("%Y%m%d")

    path = f"s3://dbt-training-datalake-336136505312-us-east-2-an/files/members/members_vendor_{today}.csv"

    df = (
        session.read
        .option("header", "true")        
        .csv(path)
        .withColumn("process_date", today)        
    )

    return df