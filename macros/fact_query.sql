{% macro fact_query(id) %}

SELECT
   *
FROM {{ ref('account_stg') }}

WHERE id = '{{ id }}'

{% endmacro %}