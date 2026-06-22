{% snapshot dim_opportunity %}
{{
    config( 
      tags = ['snp_mdl'],
      unique_key='id',
      strategy='timestamp',
      updated_at='lastmodifieddate'      
    )
}}
select *
from {{ source('raw', 'opportunity') }}

{% endsnapshot %}