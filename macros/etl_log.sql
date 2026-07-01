{% macro log_etl_run(table_name, process_date) %}

INSERT INTO {{ ref('etl_log') }}
(
    model_name,
    process_date,
    execution_timestamp,
    rows_inserted,
    status
)

SELECT
    '{{ table_name.identifier }}',
    '{{ process_date }}',
    current_timestamp,
    count(*),
    'SUCCESS'

FROM {{ table_name }}

WHERE process_date='{{ process_date }}';

{% endmacro %}