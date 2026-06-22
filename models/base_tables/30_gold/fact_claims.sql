{{ config(
    table_type='iceberg'    
) }}

select 
    PT.CONTACT_0_NAME_FAMILY,
    PT.CONTACT_0_NAME_GIVEN_0,
    status,
    CM.TOTAL_CURRENCY,
    CM.TOTAL_VALUE Claim_Amount, 
    CM.IDENTIFIER_0_VALUE  
    from  {{ source('raw', 'patients') }} PT 
    inner join   {{ source('raw', 'claims') }} CM on PT.IDENTIFIER_0_VALUE = CM.patient_IDENTIFIER_VALUE 