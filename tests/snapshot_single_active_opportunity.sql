select
    id as opportunity_id
from {{ ref('sfdc_opportunity_snapshots') }}

where dbt_valid_to is null

group by id

having count(*) > 1