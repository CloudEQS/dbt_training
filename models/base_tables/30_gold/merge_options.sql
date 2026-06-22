{{ config(
    tags=['fact_act'],
    materialized='incremental',
    incremental_strategy='merge',
    table_type='iceberg',
    unique_key=['accountnumber','id','created_date','name','type','recordtypeid','parentid'],
    incremental_predicates=[
        "target.load_ts >= date_add('year', -4, current_date)"
    ],

    delete_condition="target.parentid = 'Y'",
    update_condition="cast(src.load_ts as date) <> current_date",
    insert_condition="cast(src.load_ts as date) = current_date"
) }}

select
    *
from {{ ref('accounts_pre_post_hook') }}