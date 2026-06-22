{{ config(   
    materialized='incremental',
    incremental_strategy='append'
) }}

select
    *
from {{ ref('account_int') }}

{% if is_incremental() %}
where cast(load_ts as date)>=date_add('day', -2, current_date)
{% endif %}