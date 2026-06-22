{{ config(
    tags=['mdl_daily']
) }}

with users as (
    select *
    from {{ ref('sfdc_user') }}
)
select
    u.id,
    u.last_modified_date_et,
    u.is_active,
    u.full_name,
    u.svp_srv_sales_team as srv_sales_team,
    u.svp_srv_team_group as srv_team_group,
    u.quote_approver_svp_id,
    u.manager_id,
    mgr.full_name as manager_name,
    u.quote_approver_manager_id
from users u

left join users mgr
    on u.manager_id = mgr.id