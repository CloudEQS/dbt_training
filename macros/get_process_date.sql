{% macro get_process_date() %}

{{ return((modules.datetime.datetime.now() - modules.datetime.timedelta(days=1)).strftime("%Y%m%d")) }}

{% endmacro %}