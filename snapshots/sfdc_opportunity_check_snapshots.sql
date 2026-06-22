{% snapshot sfdc_opportunity_check_snapshots %}
{{
    config( 
      tags = ['snp_mdl'],
      unique_key='id',
      strategy='check',
      check_cols=['stagename', 'amount','type']  
    )
}}

select *
from {{ source('raw', 'opportunity') }}

{% endsnapshot %}