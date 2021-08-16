select
    ood.organization_code,
    mtrh.request_number MO_NUMBER,
    mtrh.ATTRIBUTE_CATEGORY,
    mtrh.attribute3,
    mtrh.attribute4,
    mtrh.attribute5,
    mtrl.line_number,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mtrl.uom_code,
    mtrl.from_subinventory_code,
    mtrl.quantity mo_quantity,
    mtrl.quantity_delivered,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 mo_expense_account--,
    ---mtrh.*
from
    inv.mtl_txn_request_headers mtrh,
    inv.mtl_txn_request_lines mtrl,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    gl.gl_code_combinations gcc
where
    mtrh.header_id=mtrl.header_id
    and mtrh.request_number='4716323'    
    and mtrl.inventory_item_id=msi.inventory_item_id
    and mtrl.organization_id=msi.organization_id
    and mtrl.organization_id=ood.organization_id
    and mtrl.to_account_id=gcc.code_combination_id