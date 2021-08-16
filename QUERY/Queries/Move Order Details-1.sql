select
    mtrh.request_number,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mmt.subinventory_code,
    lt.lot_number,
    mmt.transaction_quantity--,
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_txn_request_headers mtrh,
    inv.mtl_system_items_b msi,
    inv.mtl_transaction_lot_numbers lt
where
    to_char(mmt.transaction_source_id)=mtrh.request_number
    and mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and mmt.transaction_id=lt.transaction_id(+)
    and mmt.inventory_item_id=lt.inventory_item_id(+)
    and mmt.organization_id=lt.organization_id(+)
    and mtrh.request_number in ('3528116')  
    

select
    *
from
    inv.mtl_material_transactions
where
    inventory_item_id=24453
    and subinventory_code='CER-SP FLR'    



select
    *
from
    inv.mtl_transaction_lot_numbers
where
    rownum<10    

    
select
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
--    msi.description,
    mtrl.*
from
    inv.mtl_txn_request_headers mtrh,
    inv.mtl_txn_request_lines mtrl,
    inv.mtl_system_items_b msi
where
    mtrh.header_id=mtrl.header_id
    and msi.inventory_item_id=msi.inventory_item_id
    and msi.organization_id=mtrl.organization_id
    and mtrh.organization_id=mtrl.organization_id 
    and mtrh.request_number in ('3492964','3493298')
      