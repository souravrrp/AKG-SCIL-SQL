select 
    mtrh.request_number,
    mtt.transaction_type_name,
    ood.organization_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mtrh.attribute1 vehicle_number,
    mtrl.lot_number,
    mtrl.from_subinventory_code,
    mtrl.to_subinventory_code,
    mtrl.uom_code,
    mtrl.quantity--,
--    mtrh.*,
--    mtrl.*
from
    inv.mtl_txn_request_headers mtrh,
    inv.mtl_txn_request_lines mtrl,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    inv.mtl_transaction_types mtt
where
--    mtrh.request_number in ('4234045','4234046','4234047')
    
    and mtrh.header_id=mtrl.header_id
    and mtrl.inventory_item_id=msi.inventory_item_id
    and mtrl.organization_id=msi.organization_id
    and msi.organization_id=ood.organization_id
    and mtrh.transaction_type_id=mtt.transaction_type_id    