-- macros to check negative amount in amount column
{% test assert_total_amount_is_positive(model, column_name) %}

{{ config(error_if = '<0', severity= 'warn' ) }}
select
    {{column_name}}
from {{model}}
having not( {{column_name}} >= 0)
{% endtest %}