{{ config(tags='account_view') }}

select 
    accountnumber
    ,id
    ,created_date
    ,name
    ,type
    ,recordtypeid
    ,parentid
from {{ ref('accounts_merge') }} 