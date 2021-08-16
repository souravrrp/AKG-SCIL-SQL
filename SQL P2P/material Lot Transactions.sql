select 
--    mtln.*,
    pha.segment1 po_number
    ,pda.destination_type_code
    ,pha.currency_code currency
    ,pha.rate
    ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code
    ,msi.description
    ,pla.unit_meas_lookup_code uom_code
    ,pla.unit_price
    ,pla.quantity
    ,rsh.shipment_num
    ,rsh.receipt_num
    ,rt.transaction_type
    ,rt.quantity grn_quantity
    ,rt.transaction_date
    ,rt.subinventory
    ,mtt.transaction_type_name
    ,mtln.lot_number
    ,mtln.transaction_quantity
from 
    apps.po_headers_all pha
    ,apps.po_lines_all pla
    ,apps.po_distributions_all pda
    ,apps.rcv_shipment_headers rsh
    ,apps.rcv_transactions rt
    ,apps.mtl_material_transactions mmt
    ,apps.mtl_transaction_types mtt
    ,apps.mtl_transaction_lot_numbers mtln
    ,apps.mtl_system_items msi
where 1=1 
--    and pha.cancel_flag != 'N'
    and mmt.INVENTORY_ITEM_ID = 1137564
    and mmt.ORGANIZATION_ID = 606
    and pla.po_header_id = pha.po_header_id
    and pla.po_header_id = pda.po_header_id
    and pla.po_line_id = pda.po_line_id
    and pla.org_id = pha.org_id
    and pla.org_id = pda.org_id
    and pla.item_id = mmt.inventory_item_id(+)
    and pda.destination_organization_id = mmt.organization_id(+)
    and pha.po_header_id = mmt.transaction_source_id(+)
    and pla.po_line_id=rt.po_line_id(+)
    and rt.shipment_header_id=rsh.shipment_header_id
    and pda.destination_organization_id=rsh.ship_to_org_id
    and rt.transaction_id = mmt.rcv_transaction_id(+)
    and rt.transaction_id = mmt.source_line_id(+)
    and mmt.transaction_type_id = mtt.transaction_type_id(+)
    and pla.item_id = mtln.inventory_item_id(+)
    and pda.destination_organization_id = mtln.organization_id(+)
    and rt.transaction_id = mtln.product_transaction_id(+)
    and pha.po_header_id = mtln.transaction_source_id(+)
    and pla.item_id = msi.inventory_item_id
    and pda.destination_organization_id = msi.organization_id
order by
    rt.transaction_id
    