{{ config(materialized='table') }}

SELECT * FROM {{source("delta_source", "customer")}}