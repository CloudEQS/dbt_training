{% set process_date = var('process_date') %}

{{
config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='id',
    write_compression='zstd'
)
}}

select

    id,
    name,
    accountid,
    ownerid,
    amount,        
    lastmodifieddate,

    case
        when amount < 10000 then 'Small'
        when amount <= 50000 then 'Medium'
        else 'Large'
    end as opp_segment,

    case
        when amount < 10000 then amount * 0.95
        when amount <= 50000 then amount * 0.90
        else amount * 0.85
    end as discounted_amount,

    current_timestamp as load_timestamp

from {{ source('raw','opportunity') }}

where cast(lastmodifieddate as date) >= date '{{ process_date }}'