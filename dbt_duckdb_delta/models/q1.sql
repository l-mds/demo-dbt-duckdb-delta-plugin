{{ config(materialized='table') }}

SELECT l_returnflag,
      l_linestatus,
      sum(l_extendedprice),
      min(l_extendedprice),
      max(l_extendedprice),
      avg(l_extendedprice)
      FROM {{source("delta_source","lineitem")}} lineitem
      JOIN {{source("delta_source","orders")}} orders ON (l_orderkey=o_orderkey)
      WHERE l_shipdate <= DATE '1998-09-02'
      AND o_orderstatus='O'
      GROUP BY l_returnflag, l_linestatus