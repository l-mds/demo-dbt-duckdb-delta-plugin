{{ config(materialized='table') }}

SELECT * FROM {{source("delta_source","orders")}}
--where l_linestatus = 'O'