{{
    config(
        tags=['mdl_daily']
    
) }}

with 
   source as (
    select * from {{ source('raw', 'opportunity') }}
   )
,
final as (
    select
     /* primary key */
        id as opportunity_id

     /* foreign key */
        , accountid as account_id
        , recordtypeid as record_type_id
        , createdbyid as create_by_id
        , lastmodifiedbyid as last_modified_by_id
        , ownerid as owner_id
        , pricebook2id as price_book_id
        , campaignid as campaign_id
        , salesforce_18_digit_id__c as salesforce_18_digit_id
            
        /* timestamps */    

        , cast(try_cast(createddate as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as created_at_et
        , cast(try_cast(lastmodifieddate as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as last_modified_date_et
        , cast(try_cast(edw_load_datetime as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as edw_load_datetime_et
        , cast(try_cast(closedate as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as close_date_et

        /* status and properties */
        , name 
        , description
        , stagename as stage
        , amount
        , type
        , expectedrevenue as expected_amount
        , totalopportunityquantity as total_quantity
        , leadsource as lead_source
        , isclosed as closed
        , iswon as is_won
        , forecastcategory as forecast_category
        , forecastcategoryname as forecast_category_name
        , currencyisocode as currency_iso_code
        , hasopportunitylineitem as has_line_item
        , issplit as is_split
        , systemmodstamp as system_modstamp
        , lastactivitydate as last_activity
        , fiscalquarter as fiscal_quarter
        , fiscalyear as fiscal_year
        , fiscal as fiscal_period
        , lastvieweddate as last_viewed_date
        , lastreferenceddate as last_referenced_date
        , hasoverduetask as has_overdue_task
        , product_type__c as product_type
        , usage_type__c as usage_type
        , partner_level__c as partner_level
        , partner__c as partner
        , contract_period__c as contract_period
        , x2nd_yr_amount__c as second_yr_amount
        , x3rd_yr_amount__c as third_yr_amount
        , multi_year_amount__c as multi_year_amount
        , asset__c as asset
        , transfer_to_am_now__c as transfer_ownership_to_account_manager
        , downtick_value__c as downtick_value
        , product_description__c as product_description
        , renewal_due_date__c as renewal_expiration_date
        , fastalert__c as fastalert
        , visual_command_center__c as visual_command_center_amount
        , it_alerting_deal__c as is_it_alerting_deal
        , emergency_notification_deal__c as is_emergency_notification_deal
        , visual_command_center_deal__c as is_visual_command_center_deal
        , safety_connection_deal__c as is_safety_connection_deal
        , ums_lead_source__c as ums_lead_source
        , ums_est_close_date__c as ums_est_close_date
        , ums_type__c as ums_type
        , ums_stage__c as ums_stage
        , ums_product_delivery_mode__c as ums_product_delivery_mode
        , ums_product__c as ums_product
        , ums_establishment_cost__c as ums_establishment_cost
        , ums_annual__c as ums_annual
        , ums_establishment_annual__c as ums_establishment_plus_annual
        , ums_total_cost__c as ums_total_cost
        , ums_actual_revenue__c as ums_actual_revenue
        , ums_training_cost__c as ums_training_cost
        , ums_total_amount__c as ums_total_amount
        , ums_contact__c as ums_contact
        , growth_type__c as growth_type
        , opportunity_account_manager_manager__c as opportunity_account_manager_manager
        , opportunity_account_manager__c as opportunity_account_manager
        , smt_report_approved_date__c as smt_report_approved_date
        , qfa_date__c as qfa_date
        , budgeted__c as is_budgeted
        , what_who_could_stop_this__c as is_what_who_could_stop_this
        , time_bound_incentive__c as time_bound_incentive
        , incentive_details__c as incentive_details
        , owner_manager_email__c as owner_manager_email
        , running_user_oppty_account_manager__c as running_user_oppty_account_manager
        , smt_report_comments__c as smt_report_comments
        , expected_revenue__c as expected_revenue
        , partner_notes__c as partner_notes
        , oppty_correction_escalation_date_time__c as oppty_correction_escalation_date_time
        , oppty_corrections_completed_date_time__c as oppty_corrections_completed_date_time
        , owner_department_vp_email__c as owner_department_vp_email
        , pending_legal_approval1__c as pending_legal_approval1
        , prorating_issue1__c as prorating_issue1
        , sales_ops_reviewed__c as sales_ops_reviewed
        , signed_amendment__c as signed_amendment
        , signed_msa_if_applicable__c as signed_msa__if_applicable
        , account_product_region__c as account_product_region
        , proposed_account_product_region__c as proposed_account_product_region
        , aba_new_growth__c as annual_bookings_amount_new_growth
        , total_oppty_annual_booking_amount__c as total_oppty_annual_booking_amount
        , risk_intelligence_amount__c as risk_intelligence_amount
        , crisis_management_amount__c as crisis_management_amount
        , of_ps_products_sold__c as no_of_ps_products_sold
        

    from source
)
select * from final