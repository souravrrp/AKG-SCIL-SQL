select 
ITEM_NUMBER, ITEM_DESCRIPTION, UOM_CODE, 
sum(line_quantity) Quantity
--max(CONFIRM_DATE)
--ITEM_NUMBER, sum(LINE_QUANTITY), count(*) 
from apps. XXAKG_OE_DO2MOVE_V where org_id=83 
--and TO_CHAR(CONFIRM_DATE,'YYYYMMDD')=20160719
--and CONFIRM_DATE > to_date('22-JUL-2016 00:00:00','DD-MON-YYYY hh24:mi:ss') 
and MOV_ORDER_NO between :from_mov and :to_mov--MO/COU/017773
--and CONFIRM_DATE < to_date('23-JUL-2016 00:00:00','DD-MON-YYYY hh24:mi:ss') 
group by ITEM_NUMBER, ITEM_DESCRIPTION, UOM_CODE
order by ITEM_NUMBER
