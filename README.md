# dbt-duckdb-delta-plugin-demo
An example project for duckdb delta integration

## Usage and read delta table
profiles.yml
````yaml
default:
  outputs:
    dev:
      type: duckdb
      plugins: 
        - module: delta
  target: dev
````
source.yml
````yaml
version: 2
sources:
  - name: delta_source
    config:
      plugin: delta
      materialization: view #VERY IMPORTANT CONFIG TO PUSHDOWN PREDICATES
    tables: 
    - name: customer
      meta:
        delta_table_path: "../sf1/delta/customer"
````
customer_raw.sql
````sql
{{ config(
        materialized='table'    
)}}

SELECT * FROM {{source("delta_source", "customer")}}
````

You can also setup other read options or read remote table from cloud providers. For more information you can look int [source definiton](https://github.com/milicevica23/dbt-duckdb-delta-plugin-demo/blob/main/dbt_duckdb_delta/models/source.yml)


Note:
* relation which is dependent on the delta table can't be materialized as **view**
* for more remote options you can see [deltalake package](https://delta-io.github.io/delta-rs/python/usage.html#loading-a-delta-table)

