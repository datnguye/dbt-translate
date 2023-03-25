{% macro compile_money_to_words() %}
  {{ return(adapter.dispatch('compile_money_to_words', 'dbt_translate')()) }}
{% endmacro %}

{% macro default__compile_money_to_words() %}
  {%- if execute -%}
  
    CREATE SCHEMA IF NOT EXISTS {{var('num2words_schema', target.schema)}};
    {{ dbt_translate.compile_money_to_words_en() }};
    {#-- add new language here #}\

  {% endif %}
{% endmacro %}

{% macro sqlserver__compile_money_to_words() %}
  {%- if execute -%}
    {% set create_schema -%}
      IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = '{{ var("num2words_schema", target.schema) }}')
      BEGIN
        EXEC('CREATE SCHEMA [{{ var("num2words_schema", target.schema) }}]')
      END
    {% endset %}
    {% do run_query(create_schema) %}
  
    {{ dbt_translate.compile_money_to_words_en() }};
    {#-- add new language here #}

  {% endif %}
{% endmacro %}