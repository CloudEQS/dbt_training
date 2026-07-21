-- depends on: {{ ref('factclaims') }}

{{
config(
    materialized='table',
    tags=['claims_mdl'])
}}

select 1 as completed