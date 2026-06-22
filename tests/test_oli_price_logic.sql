--Pricing sanity check (unit_price should not exceed list_price when both exist)
{{ config(error_if = '<0') }}
select *
from {{ ref('sfdc_opportunitylineitem') }}
where unitprice is not null
  and listprice is not null
  and unitprice > listprice