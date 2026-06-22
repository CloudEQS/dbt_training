{{
    config(
        tags=['mdl_daily']
    )
}}
with 
   source as (
    select * from {{ source('raw', 'opportunitylineitem') }}
   )
,
final as (
    select
     /* primary key */
        id 

     /* foreign key */
        , opportunityid as opportunity_id
        , pricebookentryid as pricebook_entry_id
        , product2id as product_id
        , createdbyid as created_by_id
        , lastmodifiedbyid as lastmodified_by_id
        , oppty_product_id__c as oppty_product_id
            
        /* timestamps */
        , createddate as created_at_et
        , lastmodifieddate as last_modified_date_et
        , edw_load_datetime as edw_load_datetime_et

        /* status and properties */
        , productcode as product_code
        , name 
        , currencyisocode as currency_iso_code
        , quantity 
        , totalprice
        , unitprice
        , listprice
        , description
        , isdeleted as is_deleted
        , annual_fee__c as annual_fee
        , product_sale_type__c as product_sale_type
        , product_categorizationitemtype__c as product_categorization_item_type
        , fee_type__c as fee_type
        , quote_product_sales_type__c as quote_product_sales_type
        , opp_product_owner_vp_sales__c as opp_product_owner_vp_sales
        , product_name__c as product_name
        , opportunity_stage__c as opportunity_stage
        , discount_amount__c as discount_amount
        , check_segment_index__c as check_segment_index
        , active_product__c as active_product
        , update_record_checkbox__c as update_record_checkbox
        , number__c as number
        , product_new_growth_amount__c as product_new_growth_amount
        , product_proserve_amount__c as product_proserve_amount
        , update_for_annual_value_rk__c as update_for_annual_value_rk
        , mn_product_2__c as mn_product_2
        , update_for_dataload__c as update_for_data_load
        , product_family_2__c as product_family_2
        , product_discount_percent__c as product_discount_percent
        , annual_bookings_amount_r_w__c as annual_bookings_amount_r_w
        , annual_bookings_amount__c as annual_bookings_amount
        , sbqq__quoteline__c as sbqq_quoteline
        , sbqq__subscriptiontype__c as sbqq_subscriptiontype
        , finance_annual_amount__c as finance_annual_amount

    from source
)
select * from final 


