select 
opl.ATTRIBUTE4 PRICE_LOCATION,
opl.NAME PRICE_LIST,
--opl.DESCRIPTION,
opll.list_price,
to_char(opll.start_date_active) start_active_date,
to_char(opll.END_DATE_ACTIVE) line_end_date,
--opll.INVENTORY_ITEM_ID,
opll.CONCATENATED_SEGMENTS item_code,
opll.item_description ,
opll.UNIT_CODE
--,opl.*
from
apps.oe_price_lists opl
,apps.oe_price_list_lines opll
where 1=1
and opl.price_list_id = opll.price_list_id 
and opl.ATTRIBUTE4='Motijheel'
and opl.ATTRIBUTE10 is null
and opll.END_DATE_ACTIVE is null
and  opll.CONCATENATED_SEGMENTS NOT IN ('RMC0.SERV.0001')
--and  opll.CONCATENATED_SEGMENTS IN ('RMC0.1500.0004','RMC0.2500.0005','RMC0.2500.0003','RMC0.2500.0004','RMC0.3000.0004','RMC0.3000.0006','RMC0.3000.0005','RMC0.3500.0004','RMC0.4000.0003','RMC0.4500.0003','RMC0.5000.0003','RMC0.6000.0001')
and opll.UNIT_CODE='CFT'
AND opll.CONCATENATED_SEGMENTS='RMC0.6000.0001'--:P_ITEM_CODE


-------------------------------QP_LIST_HEADER_LINE--------------------------------------
select
*
from
apps.qp_list_headers_b qlh
,apps.qp_list_headers_tl qlt
where 1=1
and qlt.LIST_HEADER_ID=qlh.LIST_HEADER_ID
and qlh.ORIG_ORG_ID=84
--and NAME like '%Hemayetpur%'


--------------------------RMC PRICE LOCATION--------------------------------------------

SELECT
FFV.FLEX_VALUE LOCATION
--,FFV.*
FROM
APPS.FND_FLEX_VALUE_SETS VAL_SET
,APPS.FND_FLEX_VALUES FFV
WHERE 1=1
AND VAL_SET.FLEX_VALUE_SET_ID=FFV.FLEX_VALUE_SET_ID
AND FLEX_VALUE_SET_NAME='AKG_RMC_PRICE_LOCATION'
--AND FFV.FLEX_VALUE='Nawabganj'
