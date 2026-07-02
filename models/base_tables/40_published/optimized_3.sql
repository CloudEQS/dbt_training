{{
config(
    materialized='incremental',
    incremental_strategy='append',
    partitioned_by=[        
        "address_0_district"
    ],
    write_compression='zstd'    
)
}}
select 
    PT.CONTACT_0_NAME_FAMILY,
    PT.CONTACT_0_NAME_GIVEN_0,
    status,
    CM.TOTAL_CURRENCY,
    CM.TOTAL_VALUE Claim_Amount, 
    CM.IDENTIFIER_0_VALUE,
    PT.address_0_district  
    from  {{ source('raw', 'patients') }} PT 
    inner join   {{ source('raw', 'claims') }} CM on PT.IDENTIFIER_0_VALUE = CM.patient_IDENTIFIER_VALUE 