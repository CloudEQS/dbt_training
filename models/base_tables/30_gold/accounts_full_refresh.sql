{{ config(
    table_type='iceberg',
    materialized='incremental',
    incremental_strategy='append',
    pre_hook=[
    "DELETE FROM {{ this }} where
     cast(load_ts as date) = current_date"
    ],
    post_hook=[
    "UPDATE {{ this }} SET 
    parentid = 'Y' WHERE parentid IS NULL"
    ]
    
) }}

select * from {{ ref('account_int') }}





