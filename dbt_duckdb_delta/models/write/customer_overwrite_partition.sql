{{ config(
    materialized='external_table',
    plugin = 'delta',
    location = '/home/aleks/git/open-source/dbt-duckdb-delta-plugin-demo/dbt_duckdb_delta/data/customer1',
    mode = "overwrite_partition",
    partition_key = ["c_nationkey","c_mktsegment"]
) }}
select * from {{ref('customer_raw')}} 
where c_mktsegment = 'BUILDING'