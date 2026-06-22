{{
    config(
        tags=['mdl_daily']
    )
}}
with 
   source as (
    select * from {{ source('raw', 'user') }}
   )
,
final as (
    select
     /* primary key */
        id 

     /* foreign key */ 
        , profileid as profile_id
        , createdbyid as create_by_id
        , lastmodifiedbyid as  last_modified_by_id
        , contactid as contact_id
        , accountid as account_id
        , client_account_id__c as client_account_id
        , managerid as manager_id
        , quote_approver_manager__c	as quote_approver_manager_id
        , quote_approver_svp__c as quote_approver_svp_id
          
        /* timestamps */
        , createddate as created_at_et
        , lastmodifieddate as last_modified_date_et

        /* status and properties */
        , isactive as is_active
        , user_status__c as user_status
        , lastname as last_name
        , firstname as first_name
        , name as full_name
        , department
        , title
        , street
        , city
        , state
        , postalcode
        , country
        , phone
        , currencyisocode as currency_iso_code
        , srv_sales_team__c as svp_srv_sales_team
        , manager_full_name__c as manager_name
        , srv_team_group__c as svp_srv_team_group
          
    from source
)
select * from final
