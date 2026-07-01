{% set process_date = get_process_date() %}

{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='append',
    post_hook=[
            "{{ log_etl_run(process_date) }}"
        ]
) }}

select *

from {{ ref('mdl_s3') }}