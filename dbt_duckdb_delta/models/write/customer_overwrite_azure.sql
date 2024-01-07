{{ config(
    materialized='external',
    plugin = 'delta',
    location = 'abfss://test@alekstmp.dfs.core.windows.net/customer',
    mode = "overwrite" 
) }}
select * from {{ref('customer_raw')}} 