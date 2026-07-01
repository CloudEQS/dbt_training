{{
    config(
        materialized='table',
        table_type='iceberg'
    )
}}

select
    cast(null as varchar) model_name,
    cast(null as varchar) process_date,
    cast(null as timestamp) execution_timestamp,
    cast(null as bigint) rows_inserted,
    cast(null as varchar) status
where 1=0