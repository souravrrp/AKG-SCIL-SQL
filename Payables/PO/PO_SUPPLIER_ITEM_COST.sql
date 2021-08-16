Select pha.segment1 "PO_NUMBER",pla.line_num,plla.shipment_num,
pv.segment1 "Oracle_Supplier_number", msib.SEGMENT1||'.'||msib.SEGMENT2||'.'||msib.SEGMENT3 "item_number",pla.item_revision, pla.item_description,
NULL as "Delivery_date", NULL as "Blank Column", pla.unit_price, pha.rate,plla.Quantity_received,plla.Quantity_rejected,
(pla.unit_price*pla.Quantity) as "Line_Amount", NULL as "ITEM_COST", NULL as "Amount", pla.VENDOR_PRODUCT_NUM
from apps. PO_HEADERS_ALL pha,
apps. PO_VENDORS pv,
apps. PO_VENDOR_SITES_ALL pvsa,
apps. PO_LINES_ALL pla,
apps. MTL_SYSTEM_ITEMS_B msib,
apps. PO_LINE_LOCATIONS_ALL plla
where pha.org_id='85'
AND pha.org_id=pvsa.org_id
AND pv.vendor_id=pha.vendor_id
AND pvsa.vendor_id=pv.vendor_id
AND pha.po_header_id=pla.po_header_id(+)
AND pha.po_header_id=plla.po_header_id
AND plla.po_line_id(+)=pla.po_line_id
AND msib.organization_id='101'
AND pla.item_id=msib.inventory_item_id(+)
Order by pha.segment1 DESC