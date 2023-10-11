{{ config(
        materialized='table'    
)}}

SELECT c_custkey, c_nationkey 
FROM {{source("external_source", "customer")}}
where c_nationkey = 15