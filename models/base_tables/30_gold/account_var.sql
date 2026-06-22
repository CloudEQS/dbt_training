{{ config(
    table_type='iceberg',
    post_hook=[
        "UPDATE {{ this }} SET parentid = 'Y' WHERE parentid IS NULL"
    ]
) }}

select
    *
from {{ ref('account_int') }}
where load_ts between
    cast('{{ var("batch_start") }}' as date)
and cast('{{ var("batch_end") }}' as date)