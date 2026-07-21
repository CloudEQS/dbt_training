{{
config(
    materialized='table',
    tags=['claims_mdl'])
}}

select claim_id,patient_id,claim_amount,status,
case
 when claim_amount<1000 then 'Small'
 when claim_amount<=5000 then 'Medium'
 else 'Large'
end as claim_category
from {{ ref('raw_claims') }}
