{{ config(            
    pre_hook=[
        "DELETE FROM {{ this }} where year (cast(load_ts as date))=current_date and month(cast(load_ts as date))=month(current_date)"        
    ]    
) }}

select
    *
from {{ ref('account_int') }}

{% if is_incremental() %}
where cast(load_ts as date)>=date_add('day', -2, current_date)
{% endif %}