import requests
import json
import pandas as pd
from datetime import datetime, timedelta
import _snowflake
import snowflake.snowpark as snowpark
import logging

#set API Key,limit,headers
logger = logging.getLogger('failed_dbt_logger')
api_key = _snowflake.get_generic_secret_string("cred")
limit = 100
headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json"
}

# create a session for making API requests
# define the call_api function to retrieve data from the APT

def call_api(status, time_input_start, time_input_end):
    all_runs = []
    offset = 0
    while True:
        # set the parameters for the API request
        params = {
            "limit": limit,
            "offset": offset,
            "status": status
        }
        url = f"https://cloud.getdbt.com/api/v2/accounts/179022/runs?finished_at__range=['{time_input_start}','{time_input_end}']"
        resp = requests.request('GET',url=url,headers=headers,params=params,verify = False)
        data = resp.json()
        all_runs.extend(data.get('data'))
        if len(data.get("data", [])) < limit:
            break
        offset += limit
    df = pd.DataFrame(all_runs)
    if not df.empty:
        df["dbt_last_refreshed_timestamp"] = datetime.now()
        return df
    else:
        return df

# Define the model function, required by DBT
def model(dbt, session: snowpark.Session):
    dbt.config(
        materialized="incremental",
        unique_key=["id"],
        python_version="3.8",
        packages=["pandas", "requests"],
        tags=" "
    )
# Get the current time and 24 hours ago
    time_input_start = (datetime.now().replace(hour=0, minute=0, second=0) - timedelta(days=1)).strftime('%Y-%m-%d %H:%M:%S')
    time_input_end = datetime.now().replace(hour=0, minute=0, second=0).strftime('%Y-%m-%d %H:%M:%S')
# Call the API and get the resulting DataFrame
    df_result = call_api(status=20, time_input_start=time_input_start, time_input_end=time_input_end)
# if not df_result.empty:
    df_result = df_result[df_result['environment_id'].isin([225411, 228384, 251155])]
    df_result.columns=df_result.columns.str.upper()
    return df_result