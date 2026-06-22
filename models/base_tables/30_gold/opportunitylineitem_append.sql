{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        tags=['mdl_daily']
    )
}}

with source as (
    select 
        id,
        opportunity_id,
        pricebook_entry_id,
        product_id,
        created_by_id,
        lastmodified_by_id,
        oppty_product_id,
        created_at_et,
        last_modified_date_et,
        edw_load_datetime_et,
        product_code,
        name,
        currency_iso_code,
        quantity,
        totalprice,
        unitprice,
        listprice,
        description,
        is_deleted,
        annual_fee,
        product_sale_type,
        product_categorization_item_type,
        fee_type,
        quote_product_sales_type,
        opp_product_owner_vp_sales,
        product_name,
        opportunity_stage,
        discount_amount,
        check_segment_index,
        active_product,
        update_record_checkbox,
        number,
        product_new_growth_amount,
        product_proserve_amount,
        update_for_annual_value_rk,
        mn_product_2,
        update_for_data_load,
        product_family_2,
        product_discount_percent,
        annual_bookings_amount_r_w,
        annual_bookings_amount,
        sbqq_quoteline,
        sbqq_subscriptiontype,
        finance_annual_amount
    from {{ ref('sfdc_opportunitylineitem') }} 
)

select *
from source

{% if is_incremental() %}
where edw_load_datetime_et > (select max(edw_load_datetime_et) from {{ this }})
{% endif %}