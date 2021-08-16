select 
opl.ATTRIBUTE1 PRICE_LOCATION,
opl.ATTRIBUTE10 DELIVERY_MODE,
opll.list_price,
opll.start_date_active start_active_date,
opll.CONCATENATED_SEGMENTS item_code,
opll.item_description ,
opll.UNIT_CODE
from
apps.oe_price_lists opl
,apps.oe_price_list_lines opll
where 1=1
and opl.price_list_id = opll.price_list_id 
and opl.ATTRIBUTE10 is not null
and opll.END_DATE_ACTIVE is null

*****After Updating Price List:

APPS.XXAKG_QP_MODIFIER_DISCOUNT_V
APPS.QP_MODIFIER_SUMMARY_V

