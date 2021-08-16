SELECT item_description,
source_header_number order_number,
shipment_priority_code do_number,
requested_quantity_uom uom,
lot_number,
shipped_quantity qty
FROM apps.wsh_delivery_details wdd
WHERE org_id = 605 AND source_code = 'OE'
--AND LOT_NUMBER IS NOT NULL
AND EXISTS
(SELECT 1
FROM apps.oe_order_lines_all ol
WHERE line_id = wdd.source_line_id
AND org_id = wdd.org_id
AND line_category_code = 'ORDER'
--AND ACTUAL_SHIPMENT_DATE BETWEEN '01-JAN-2010' AND '07-JUL-2018'
AND TO_CHAR (actual_shipment_date, 'MON-RR') = 'OCT-19'
)


