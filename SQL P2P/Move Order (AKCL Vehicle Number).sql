select 
    mtrh.request_number
    ,mtrh.move_order_type
    ,mtt.transaction_type_name
    ,mtrh.attribute_category
    ,mtrh.attribute1
    ,mtrh.attribute2
    ,mtrl.line_number
    ,decode(mtrl.line_status,
        1,'Incomplete',
        2,'Pending Approval',
        3,'Approved',
        4,'Not Approved',
        5,'Closed',
        6,'Cancelled',
        7,'Pre-Approved',
        8,'Partially Approved',
        9,'Cancelled by Source') Move_order_status
    ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
    ,msi.description
    ,mtrl.from_subinventory_code
    ,mtrl.to_subinventory_code
    ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
    ,mtrl.UOM_code
    ,mtrl.quantity
    ,mtrl.quantity_delivered
    ,mtrl.quantity_detailed
    ,mtrl.date_required
from 
    apps.mtl_txn_request_headers mtrh
    ,apps.mtl_txn_request_lines mtrl
    ,apps.mtl_transaction_types mtt
    ,apps.mtl_system_items msi
    ,apps.gl_code_combinations gcc
where 1=1
    and mtrh.header_id=mtrl.header_id
    and mtrh.organization_id=mtrl.organization_id
    and mtrh.transaction_type_id=mtt.transaction_type_id
    and mtrl.inventory_item_id=msi.inventory_item_id
    and mtrl.organization_id=msi.organization_id
    and mtrl.to_account_id=gcc.code_combination_id
    and mtrh.organization_id in (89)
--and from_subinventory_code in ('AKC-GEN ST')
    and mtrh.attribute_category in ('AKCL Vehicle Number')