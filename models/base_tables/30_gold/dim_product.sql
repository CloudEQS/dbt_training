{{
    config(
        tags=['mdl_daily']
    )
}}
with p as (
    select * from {{ ref('sfdc_product') }}
    ),
final as (
    select
        p.id
        , p.create_by_id
        , p.record_type_id
        , p.last_modified_by_id
        , p.is_active
        , p.is_deleted
        , p.name
        , p.product_code
        , p.description
        , p.family
        from p
    left join p as p1 on (p.create_by_id = p1.id)
    left join p as p2 on (p.record_type_id = p2.id)
    left join p as p3 on (p.last_modified_by_id = p3.id)
)
select * from final