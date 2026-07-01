{% macro log_etl_run(process_date) %}

INSERT INTO {{ ref('etl_log') }}
(
    model_name,
    process_date,
    execution_timestamp,
    rows_inserted,
    status
)

SELECT
    '{{ this.identifier }}',
    '{{ process_date }}',
    current_timestamp,
    count(*),
    'SUCCESS'

FROM {{ this }}

WHERE process_date='{{ process_date }}';

{% endmacro %}