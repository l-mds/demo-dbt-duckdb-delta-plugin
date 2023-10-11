{{ config(
        materialized='table'    
)}}

SELECT *
FROM {{source("delta_source", "customer")}}
where c_nationkey = 15
limit 10