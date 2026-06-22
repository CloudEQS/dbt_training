{{ config(tag="account_ephemeral") }}

select distinct
    id
    ,accountnumber
    ,name
    ,createddate as created_date
    ,upper(type) as type
    ,recordtypeid
	,parentid
    ,load_ts
from {{ ref('account_ephemeral') }}
where createddate is not null