{{
config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='claim_id',
    write_compression='zstd',
    tags=['claims_mdl'])
}}
select *
from {{ ref('stg_claims_data_s3') }}