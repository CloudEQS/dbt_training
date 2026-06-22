{% snapshot snp_opportunitylineitem %}
{{
    config( 
      tags = ['snp_mdl'],
      unique_key='id',
      strategy='timestamp',
      updated_at='lastmodifieddate'
   
    )
}}
select *
from {{ source('raw_bronze', 'opportunitylineitem') }}

{% endsnapshot %}