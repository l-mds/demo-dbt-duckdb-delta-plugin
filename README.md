# demo-duckdb-delta-plugin
An example project for duckdb delta integration

**This project uses the latest development from delta plugin**
The current PR is here https://github.com/duckdb/dbt-duckdb/pull/284

**To use predicate pushdown you have to setup materialization to be a view!**

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
      materialization: view #It is default now; more in TL;DR;
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


## TL;DR;
## What is __materialization: view__ and why it’s needed?

Will try to setup the answer and please correct me if i am wrong

### What is a delta table?

It is a folder with many parquet files, which are normally just added, and a transaction log folder with definition, which parquet files build up our last version of the tables. You can imagine that readers and writers add and delete parquet files and are synchronized over the transaction log folder.

### What is predicate pushdown?

You want to load less data into RAM memory while doing so,me transformation; therefore you want to push down your filters and selections to the file reader. You can imagine that arrow is file reader in that situation and what you want is to give to that reader as much information what you need in order to skip loading into memory. This is possible because of the parquet file specific metadata representation which allows the reader to skip not needed data. This is called a zone map.

### How delta-rs works?

It is a python package which is using arrow representation and datafusion as engine. It provides also python interface which you can use.

### What is arrow format?
It is a common representation of the data in the memory which means that it is possible to exchange a pointer to some memory and other process would be able to read this memory without copy and use further.
How do duckdb and deltars work together?
Duckdb and deltars(data fusion) “speaks” arrow so it means you can read something in delta rs and hand it over to duckdb engine in a format that both understand.

The funny and important part is what if you define a filter in duckdb query on a arrow instance that comes from delta rs delta table instance. You can do that as described here
https://delta-io.github.io/delta-rs/python/usage.html#querying-delta-tables
The duckdb push information to arrow in deltars to read and skip stuff.
How dbt-duckdb plugin generally work?
You define a source config that point to a path where the data is. You also define one or more dbt models which depend on that source. Every time when dbt starts to build up the model it has a specific code path where you can intersect and ingest your code. This is where the plugin jumps in and do somthing extra depending on your source config. Either creates a table or a view in duckdb.

Create table t as select * from df
Create view t as select * from df

The important thing here is to understand the time of data pulling/reading execution.
If we create a table the data will be fully loaded into a duckdb table by executing this statement. This statement is executed before model creation. Therefore we don’t have information what is really needed but rather load everything.
If we create a view just the definition of the view is created but the data is pulled the first time when something pulls data from that view.

The nice thing about this is that the model that depends on this view/source is now pulling data and duckdb can understand that and push filters and selection predicates the whole way down to the view and further to the arrow that is reading the data. This makes loading much faster and it makes just what is needed and defined by the model.
You can imagine this is handy when you have a big table but you want to load  just a small subset of the data.
You can try it yourself and see the query plan and you will feel the difference. Look into my example project profile file to see how you can write out the query plan

