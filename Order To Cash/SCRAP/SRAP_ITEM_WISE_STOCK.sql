SELECT 
--l.ship_from_org_id,
(select organization_code from apps.mtl_parameters where organization_id=l.ship_from_org_id) organization_code,
--l.inventory_item_id,
l.ordered_item,
msi.description item_description,
SUM (l.ordered_quantity) ordered_quantity,
order_quantity_uom,
msi.primary_uom_code,
nvl((select sum(ohd.primary_transaction_quantity) from apps.mtl_onhand_quantities_detail ohd where ohd.organization_id=l.ship_from_org_id and ohd.inventory_item_id=l.inventory_item_id),0) ohd_prm_qty
FROM apps.oe_order_lines_all l, apps.oe_order_headers_all h, apps.mtl_system_items_b msi
WHERE h.header_id = l.header_id
AND l.inventory_item_id = msi.inventory_item_id
AND l.ship_from_org_id = msi.organization_id
AND h.order_type_id = 1101
AND l.flow_status_code = 'AWAITING_SHIPPING'
AND l.line_category_code = 'ORDER'
AND l.shipment_priority_code IS NOT NULL
AND l.actual_shipment_date IS NULL
GROUP BY l.inventory_item_id,
l.ordered_item,
msi.description,
order_quantity_uom,
msi.primary_uom_code,
l.ship_from_org_id
