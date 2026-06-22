{% snapshot snp_opportunitylineitem_selected %}
{{
    config( 
      tags = ['snp_mdl'],
      unique_key='id',
      strategy='check',
      check_cols=['fee_type__c', 'partial_growth_amt__c','totalprice']  
   
    )
}}
select *
from {{ source('raw_bronze', 'opportunitylineitem') }}

{% endsnapshot %}