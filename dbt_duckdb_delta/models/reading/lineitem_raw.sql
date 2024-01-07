{{ config(materialized='table') }}

SELECT * FROM {{source("delta_source","lineitem")}} where l_linestatus = 'O'