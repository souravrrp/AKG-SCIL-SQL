select
dodl.order_number,
sum(dodl.line_quantity) over (partition by dodl.order_number) as quantity
from
apps.xxakg_del_ord_do_lines dodl
where 1=1
and dodl.order_number='650004368'
--and rownum<=5

select --count(dodl.line_quantity),
dodl.order_number
,dodl.line_quantity
from
apps.xxakg_del_ord_do_lines dodl
where 1=1
--and rownum<=10
and dodl.order_number=650004368--'1100044'-----650004361--650004347--650004346
--group by dodl.order_number
--order by dodl.order_number desc

select
dodl.order_number,
lag(dodl.line_quantity) over (partition by dodl.order_number order by dodl.order_number) as quantity
from
apps.xxakg_del_ord_do_lines dodl
where 1=1
and dodl.order_number='650004368'
--and rownum<=5

select
dodl.order_number,
lag(dodl.line_quantity) over (order by dodl.order_number) as quantity
from
apps.xxakg_del_ord_do_lines dodl
where 1=1
--and dodl.order_number='650004368'
and rownum<=5
