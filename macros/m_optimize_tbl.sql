{% macro optimize_all_tables() %}

{% set models = [
    'dim_user',
    'fact_claims'    
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