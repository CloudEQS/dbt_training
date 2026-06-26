def model(dbt, spark):
    # 1. dbt Configuration
    dbt.config(
        materialized="table",
    )

    # 2. Force older urllib3 to match Athena's OpenSSL version
    import sys
    import subprocess
    
    target_dir = "/tmp/custom_libs"
    
    # Download simple-salesforce AND explicitly downgrade urllib3
    subprocess.check_call([
        sys.executable, "-m", "pip", "install", 
        "simple-salesforce", "urllib3<2", 
        "--target", target_dir
    ])
    
    # Force Python to look in our custom folder FIRST
    if target_dir not in sys.path:
        sys.path.insert(0, target_dir)

    # 3. Now the import .
    from simple_salesforce import Salesforce
    import pandas as pd

    # 4. Authenticate with Salesforce 
    sf = Salesforce(
        username='params@cloudeqs.com', 
        password='SF@CX@2026!n', 
        security_token='IX4pZcmqj6kcipmN7PjXSeUn', 
        domain='login'
    )

    # 5. Extract Data via SOQL 
    query = "SELECT Id, Name, Type, Industry, AnnualRevenue, CreatedDate FROM Account"
    result = sf.query_all(query)

    # 6. Load into Pandas DataFrame to clean it up
    records = result['records']
    pandas_df = pd.DataFrame(records)
    
    pandas_df = pandas_df.drop(columns=['attributes'], errors='ignore')
    pandas_df['CreatedDate'] = pd.to_datetime(pandas_df['CreatedDate'])

    # 7. Convert Pandas to Apache Spark DataFrame
    spark_df = spark.createDataFrame(pandas_df)

    return spark_df
