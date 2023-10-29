{{ config(
    materialized='external_table',
    plugin = 'delta',
    location = '/home/aleks/git/open-source/dbt-duckdb-delta-plugin-demo/dbt_duckdb_delta/data/delta_lineitem',
    mode = "merge", 
    unique_key = ["l_orderkey"]
) 
}}
select * from {{ref('lineitem_raw')}} 