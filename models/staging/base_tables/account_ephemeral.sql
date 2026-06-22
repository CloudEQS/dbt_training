{{ config(materialized='ephemeral') }}

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
	,current_timestamp as load_ts
from {{ source('raw', 'account') }}