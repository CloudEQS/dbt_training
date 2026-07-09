{{
config(
    materialized='table'
)
}}

select *
from {{ ref('mdl_s3') }}