--EXTERNAL TABLE MATERIALIZATION IS JUST A TEMP SOLUTION TILL WE DONT REFACTOR 
--WHEN THE PR WILL BE MERGED IT SHOULD BE JUST EXTERNAL
--THIS CAN BE REFERENCED IN THE NEXT STEP AND SHOULD BE SEEN AS THE SERVING/LAST LAYER
{{ config(
    materialized='external_table',
    plugin = 'delta',
    location = 'abfss://test@alekstmp.dfs.core.windows.net/customer',
    mode = "overwrite" 
) }}
select * from {{ref('customer_raw')}} 