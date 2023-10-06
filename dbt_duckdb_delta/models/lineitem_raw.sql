{{ config(materialized='table') }}

SELECT l_partkey,l_linestatus FROM {{source("delta_source","lineitem")}}
where l_linestatus = 'O'