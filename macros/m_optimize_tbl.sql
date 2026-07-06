{% macro optimize_all_tables() %}

{% set models = [
    'customer_history',
    'sales_history',
    'product_history'
] %}

{% for model in models %}

    {% do run_query(
        "OPTIMIZE " ~ ref(model) ~ " REWRITE DATA USING BIN_PACK"
    ) %}

    {% do run_query(
        "VACUUM " ~ ref(model)
    ) %}

{% endfor %}

{% endmacro %}