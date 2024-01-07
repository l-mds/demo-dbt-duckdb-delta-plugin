SELECT * from {{source("delta_source", "customer1")}}
where c_mktsegment = 'BUILDING' --where c_phone = '123' --c_mktsegment = 'BUILDING'