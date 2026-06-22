{{
    config(
        tags=['mdl_daily']
    )
}}
with 
   source as (
    select * from {{ source('raw', 'product') }}
   )
,
final as (
    select
     /* primary key */
        id 

     /* foreign key */
        , createdbyid as create_by_id
        , recordtypeid as record_type_id
        , lastmodifiedbyid as last_modified_by_id
        
     /* timestamps */
        , createddate as created_at_et
        , lastmodifieddate as last_modified_date_et
        , edw_load_datetime as edw_load_datetime

        /* status and properties */
        , isactive as is_active
        , isdeleted as is_deleted
        , name
        , productcode as product_code
        , description
        , family
        , currencyisocode as currency_iso_code
        , product_class__c as product_class
        , product_family_group__c as product_family_group
        , vertical_markets__c as vertical_markets
        , quotation_grouping_type__c as quotation_grouping_type
        , categorization_item_type__c as categorization_item_type
        , fee_type__c as fee_type
        , tax_code__c as tax_code
        , product_sub_class__c as product_sub_class
        , no_discount_item__c as no_discount_item
        , name_length__c as name_length
        , quotegrouping_order__c as quotegrouping_order
        , disable_proration__c as disable_proration
        , has_setup_fee__c as has_setup_fee
        , sbqq__costeditable__c as sbqq_costeditable
        , sbqq__descriptionlocked__c as sbqq_descriptionlocked
        , sbqq__excludefrommaintenance__c as sbqq_exclude_from_maintenance
        , sbqq__includeinmaintenance__c as sbqq_include_in_maintenance
        , sbqq__nondiscountable__c as sbqq_non_discountable
        , sbqq__priceeditable__c as sbqq_price_editable
        , sbqq__pricingmethodeditable__c as sbqq_pricing_method_editable
        , sbqq__quantityeditable__c as sbqq_quantity_editable
        , sbqq__subscriptiontype__c as sbqq_subscription_type
        , steelbrick_product_sort__c as steelbrick_product_sort
        , sbqq__subscriptionpricing__c as sbqq_subscription_pricing
        , gsa_classification__c as gsa_classification
        , sbqq__defaultpricingtable__c as sbqq_default_pricing_table
        , sbqq__sortorder__c as sbqq_sortorder
        , minimum_members__c as minimum_members
        , max_members__c as max_members
        , price_type__c as price_type
        , sbqq__pricingmethod__c as sbqq_pricing_method
       

    from source
)
select * from final
