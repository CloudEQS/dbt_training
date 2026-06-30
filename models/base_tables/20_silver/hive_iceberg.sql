{{ 
  config(tag="account")
}}

select * from {{ ref('py_mdl') }}
