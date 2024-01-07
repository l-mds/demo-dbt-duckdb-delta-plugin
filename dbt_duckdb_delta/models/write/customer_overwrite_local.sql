{{ config(
    materialized='external',
    plugin = 'delta',
    location = '/home/aleks/git/open-source/dbt-duckdb-delta-plugin-demo/dbt_duckdb_delta/data/customer1',
    mode = "overwrite" 
) }}
select * from {{ref('customer_raw')}} 