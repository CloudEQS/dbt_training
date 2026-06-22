{{ config(    
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['accountnumber','id','created_date','name','type','recordtypeid','parentid']
) }}

select
    *
from {{ ref('account_int') }}

{% if is_incremental() %}
where ( cast(load_ts as date)>=date_add('day', -2, current_date) or cast(modify_ts as date)>=date_add('day', -2, current_date))
{% endif %}