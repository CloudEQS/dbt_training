{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    table_type='iceberg',
    unique_key=['id'],
    merge_exclude_columns=['load_ts'],
    merge_update_columns=['name', 'type', 
        'recordtypeid', 'parentid', 'billingstreet',
        'billingcity', 'billingstate', 'billingpostalcode',
        'billingcountry', 'phone', 'fax', 'accountnumber']
) }}

select
    id ,accountnumber , name , created_date ,
    type , recordtypeid , parentid ,load_ts
from {{ ref('account_int') }}

{% if is_incremental() %}
where cast(load_ts as date) >= date_add('day', -2, current_date)
{% endif %}




