--EXTERNAL TABLE MATERIALIZATION IS JUST A TEMP SOLUTION TILL WE DONT REFACTOR 
--WHEN THE PR WILL BE MERGED IT SHOULD BE JUST EXTERNAL
--THIS CAN BE REFERENCED IN THE NEXT STEP AND SHOULD BE SEEN AS THE SERVING/LAST LAYER
{{ config(
    materialized='external_table',
    plugin = 'delta',
    location = 'abfss://test/customer',
    mode = "overwrite",
    storage_options = {
        "account_name": "devstoreaccount1",
        "account_key": "Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==",
        "endpoint": "http://127.0.0.1:10000/",
        "use_emulator": "true"
    }
) }}
select * from {{ref('customer_raw')}} 