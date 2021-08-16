select cust.account_number
,hpa.party_name
,a.order_number
,trunc(a.ORDERED_DATE) order_date
--,decode(a.TP_ATTRIBUTE1,'Y','Approved','Not Approved') Status
,decode(a.FLOW_STATUS_CODE,'BOOKED','Booked','CLOSED','Booked','ENTERED',decode(a.TP_ATTRIBUTE1,'Y','Approved','Not Approved')) status
,b.line_number||'.'||b.shipment_number line_number
,b.ordered_item
,mti.description
,b.ordered_quantity
,b.order_quantity_uom uom
,b.unit_selling_price
,c.length
,c.width
,c.length*c.width size_in_inch
,decode(b.order_quantity_uom,'SFT',round(decode(c.length*c.width,0,0,nvl(b.ordered_quantity,0)*144/(c.length*c.width)),0),NULL) pcs
from apps.oe_order_headers_all a
,apps.oe_order_lines_all b
,apps.oe_order_lines_all_dfv c
,apps.hr_operating_units hou
,apps.hz_cust_accounts cust
,apps.hz_parties hpa
,apps.mtl_system_items_b_kfv mti
where 1=1
and a.header_id=b.header_id
and b.inventory_item_id=mti.inventory_item_id
and b.ship_from_org_id=mti.organization_id
and a.sold_to_org_id=cust.cust_account_id
and cust.party_id=hpa.party_id
and a.org_id=hou.organization_id
and b.context=c.context_value(+) 
and b.rowid=c.rowid(+)
and c.context_value(+) = 'AKG Marble Order Info'
and hou.name='MARBLE OPERATING UNIT'
and a.FLOW_STATUS_CODE<>'CANCELLED'
AND a.order_number=:P_ORDER_NUMBER
order by  line_number,a.order_number