from datetime import datetime,timedelta
from pyspark.sql.functions import current_timestamp


def file_exists(session, path):

    jvm = session._jvm

    hadoop_conf = session._jsc.hadoopConfiguration()

    fs = jvm.org.apache.hadoop.fs.FileSystem.get(hadoop_conf)
   
    
    return fs.exists(jvm.org.apache.hadoop.fs.Path(path))

def model(dbt, session):

    dbt.config(
        tag="members_vendor"        
     )
    


    today = datetime.now().strftime("%Y%m%d")
    today = (datetime.now() - timedelta(days=1)).strftime("%Y%m%d")

    path = f"s3://dbt-training-datalake-336136505312-us-east-2-an/files/members/members_vendor_{today}.csv"

    # if not file_exists(session, path):
    #     raise FileNotFoundError(f"Input file not found: {path}")

    df = (
        session.read
        .option("header", "true")        
        .csv(path)       
    )

    return df