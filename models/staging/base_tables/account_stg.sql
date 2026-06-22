{{ config(tag="account") }}

select DISTINCT
    id
	,isdeleted
	,masterrecordid
	,name
	,type
	,recordtypeid
	,parentid
	,billingstreet
	,billingcity
	,billingstate
	,billingpostalcode
	,billingcountry
	,billinglatitude
	,billinglongitude
	,billinggeocodeaccuracy
	,billingaddress
	,shippingstreet
	,shippingcity
	,shippingstate
	,shippingpostalcode
	,shippingcountry
	,shippinglatitude
	,shippinglongitude
	,shippinggeocodeaccuracy
	,shippingaddress
	,phone
	,fax
	,accountnumber
    ,createddate
	,cast(try_cast(createddate as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as load_ts
	,cast(try_cast(lastmodifieddate as timestamp) AT TIME ZONE 'America/New_York' as timestamp) as modify_ts
from {{ source('raw', 'account') }}