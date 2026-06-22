{% macro create_fact_tables() %}
    {% set iceberg_base_location = var('iceberg_base_location') %}

    {% set get_accounts %}
        SELECT account_id
        FROM {{ ref('account_data') }} 
    {% endset %}

    {% set results = run_query(get_accounts) %}

    {% if execute %}

        {% set account_ids = results.columns[0].values() %}

        {% for acc_id in account_ids %}

            {% set drop_sql %}
                DROP TABLE IF EXISTS fact_act_{{ acc_id }}
            {% endset %}

            {% do run_query(drop_sql) %}

            {% set create_sql %}

                CREATE TABLE fact_act_{{ acc_id  }}
                WITH (
                    table_type='ICEBERG',
                    is_external=false,
                    location = '{{ iceberg_base_location }}/fact_act_{{ acc_id }}/'
                ) AS

                SELECT
                    *
                FROM {{ ref('account_stg') }}

                WHERE id = '{{ acc_id }}'

            {% endset %}

            {{ log("Creating table for account_id: " ~ acc_id, info=True) }}

            {% do run_query(create_sql) %}

        {% endfor %}

    {% endif %}

{% endmacro %}