{{ config(tag="account") }}

select distinct
    id
    ,accountnumber
    ,name
    ,ISDELETED
    ,createddate as created_date
    ,upper(type) as type
    ,recordtypeid
	,parentid
    ,load_ts
    ,modify_ts
from {{ ref('account_stg') }}
where createddate is not null