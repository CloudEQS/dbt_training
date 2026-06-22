{{ config(
    table_type='iceberg',
    materialized='incremental',
    incremental_strategy='append',
    pre_hook=[
        "DELETE FROM {{ this }} where cast(load_ts as date)=current_date"
    ],
    post_hook=[
        "UPDATE {{ this }} SET parentid = 'Y' where parentid =''"
    ]
) }}

select
    *
from {{ ref('account_int') }}

{% if is_incremental() %}
where cast(load_ts as date)>=date_add('day', -2, current_date)
{% endif %}