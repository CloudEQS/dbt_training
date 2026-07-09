+{% set process_date = get_process_date() %}

{{ config(
    materialized='incremental',
    table_type='iceberg',
    incremental_strategy='merge',
    unique_key='opportunity_id',
    post_hook=[
            "{{ log_etl_run(process_date) }}"
        ]
) }}

with
    opp as (
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

    from  {{ source('raw', 'opportunity') }}
    ),
    oli as (select  
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

    from  {{ source('raw', 'opportunitylineitem') }} )    
    select
            /* primary key */
            opp.opportunity_id,

            /* foreign key */
            opp.account_id,
            opp.record_type_id,
            opp.create_by_id,
            opp.last_modified_by_id,
            opp.owner_id,
            opp.price_book_id,
            opp.campaign_id,
            opp.salesforce_18_digit_id,
            
            /* timestamps */
            opp.created_at_et,
            opp.last_modified_date_et,
            opp.edw_load_datetime_et,
            opp.close_date_et,

            /* status and properties */
            opp.name,
            opp.description,
            opp.stage,
            opp.amount,
            opp.type,
            opp.expected_amount,
            opp.total_quantity,
            opp.lead_source,
            opp.closed,
            opp.is_won,
            opp.forecast_category,
            opp.forecast_category_name,
            opp.currency_iso_code,
            opp.has_line_item,
            opp.is_split,
            opp.system_modstamp,
            opp.last_activity,
            opp.fiscal_quarter,
            opp.fiscal_year,
            opp.fiscal_period,
            opp.last_viewed_date,
            opp.last_referenced_date,
            opp.has_overdue_task,
            opp.product_type,
            opp.usage_type,
            opp.partner_level,
            opp.partner,
            opp.contract_period,
            opp.second_yr_amount,
            opp.third_yr_amount,
            opp.multi_year_amount,
            opp.asset,
            opp.transfer_ownership_to_account_manager,
            opp.downtick_value,
            opp.product_description,
            opp.renewal_expiration_date,
            opp.fastalert,
            opp.visual_command_center_amount,
            opp.is_it_alerting_deal,
            opp.is_emergency_notification_deal,
            opp.is_visual_command_center_deal,
            opp.is_safety_connection_deal,
            opp.ums_lead_source,
            opp.ums_est_close_date,
            opp.ums_type,
            opp.ums_stage,
            opp.ums_product_delivery_mode,
            opp.ums_product,
            opp.ums_establishment_cost,
            opp.ums_annual,
            opp.ums_establishment_plus_annual,
            opp.ums_total_cost,
            opp.ums_actual_revenue,
            opp.ums_training_cost,
            opp.ums_total_amount,
            opp.ums_contact,
            opp.growth_type,
            opp.opportunity_account_manager_manager,
            opp.opportunity_account_manager,
            opp.smt_report_approved_date,
            opp.qfa_date,
            opp.is_budgeted,
            opp.is_what_who_could_stop_this,
            opp.time_bound_incentive,
            opp.incentive_details,
            opp.owner_manager_email,
            opp.running_user_oppty_account_manager,
            opp.smt_report_comments,
            opp.expected_revenue,
            opp.partner_notes,
            opp.oppty_correction_escalation_date_time,
            opp.oppty_corrections_completed_date_time,
            opp.owner_department_vp_email,
            opp.pending_legal_approval1,
            opp.prorating_issue1,
            opp.sales_ops_reviewed,
            opp.signed_amendment,
            opp.signed_msa__if_applicable,
            opp.account_product_region,
            opp.proposed_account_product_region,
            opp.annual_bookings_amount_new_growth,
            opp.total_oppty_annual_booking_amount,
            opp.risk_intelligence_amount,
            opp.crisis_management_amount,
            opp.no_of_ps_products_sold,

            oli.id as line_item_id,
            oli.pricebook_entry_id,
            oli.product_id,
            oli.product_code,
            oli.name as opportunity_product_name,
            oli.quantity,
            oli.totalprice as total_price,
            oli.unitprice as sales_price,
            oli.listprice as list_price,
            oli.description as line_description,
            oli.created_by_id as li_created_by_id,            
            oli.lastmodified_by_id as li_last_modified_by_id,
            oli.is_deleted as li_deleted,
            oli.annual_fee,
            oli.product_sale_type,
            oli.product_discount_percent,
            oli.fee_type,
            oli.product_family_2,
            oli.opp_product_owner_vp_sales,
            oli.opportunity_stage,
            oli.active_product as is_active_product,
            oli.annual_bookings_amount_r_w,
            oli.quote_product_sales_type,
            '{{process_date}}' as process_date

        from opp as opp
        inner join oli as oli on opp.salesforce_18_digit_id = oli.opportunity_id
        inner join  {{ source('raw', 'account') }} a on opp.account_id = a.id 
    
    {% if is_incremental() %}
        where last_modified_date_et >= (select max(last_modified_date_et) from {{ this }})
    {% endif %}