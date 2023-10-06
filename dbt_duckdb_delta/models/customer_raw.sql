{{ config(
        materialized='table'    
)}}

SELECT c_custkey, c_nationkey 
FROM {{source("delta_source", "customer")}}
where c_nationkey = 15