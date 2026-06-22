{{
    config(
        tags=['mdl_daily']
) }}

with 
   source as (
    select * from {{ source('raw', 'account') }}
   )
,
final as (
    select
     /* primary key */
        id as customer_id

     /* foreign key */
        , parentid as parent_id
        , recordtypeid as record_type_id
        , createdbyid as create_by_id
        , lastmodifiedbyid as last_modified_by_id
        , ownerid as owner_id
        
            
        /* timestamps */
        ,createddate as created_at_et
        ,lastmodifieddate as last_modified_date_et   

        /* status and properties */
        , name as customer_name
        , billingstate as billing_state
        , billingcity as billing_city
        , billingcountry as billing_country
        , shippingcountry as shipping_country
        , shippingcity as shipping_city
        , shippingstreet as shipping_street
        , phone
        , industry
        , description
        , cast(current_timestamp as timestamp) as dbt_last_refreshed_timestamp

    from source
)
select * from final