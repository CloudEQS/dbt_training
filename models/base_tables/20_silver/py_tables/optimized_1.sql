{{
config(
    materialized='table',
    post_hook=[
        "MSCK REPAIR TABLE {{ this }}"
    ]
)
}}

select *
from {{ ref('mdl_S3') }}