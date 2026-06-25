{{ config(tags=['mdl_daily']) }}

select  
     a.customer_id
    , a.customer_name
    , o.opportunity_id
    , o.name as opportunityname
    , oli.product_id
    , concat(a.customer_id, oli.product_id) as custprodkey
    ,'renewal' as productsaletype 
    , oli.currency_iso_code as currency
    , oli.total_price as amount
    , case when oli.total_price is null then 0 else oli.total_price end as partialgrowthamount
    ,'renewal' as smtreportapproveddate
    , a.shipping_country as customer_shipping_country
    , o.type as opportunitytype
    ,'renewal' as opportunityowner
    , o.stage
from {{ ref('opportunity_details_int') }} o
join {{ ref('opportunity_details_int') }} oli 
    on oli.opportunity_id = o.opportunity_id 
    and oli.li_deleted = false
left join {{ ref('sfdc_account') }} a on a.customer_id = o.account_id
left join {{ ref('dim_product') }} p on p.id = oli.product_id 
left join {{ ref('dim_user') }} u on o.owner_id = u.id
where o.stage = '6-closed won'