    
select
    mmt.transaction_id,
    mmt.reason_id,
    mmt.transaction_date,
    mtt.transaction_type_name,
    mtrh.request_number mo_number,
    mtrh.created_by,
    mtrh.attribute1 vehicle_number,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mc.segment1,
    mc.segment2,
    ood.organization_code,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    lt.lot_number,
    nvl(lt.transaction_quantity,mmt.transaction_quantity) transaction_quantity,
--    mmt.transaction_quantity,
    mmt.transaction_uom,
    abs(nvl(lt.transaction_quantity,mmt.transaction_quantity))*nvl(apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')),0) txn_value,
    mmt.distribution_account_id, 
    gcc.code_combination_id gl_code_combination_id,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 dist_code_combination--,
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_types mtt,
    inv.mtl_txn_request_headers mtrh,
--    inv.mtl_txn_request_lines mtrl,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    gl.gl_code_combinations gcc,
    inv.mtl_transaction_lot_numbers lt,
    apps.org_organization_definitions ood
where
--    mmt.transaction_id in (60545327)
--    and 
    mmt.transaction_type_id=mtt.transaction_type_id
--    and mmt.transaction_source_type_id=4
--    and mmt.transaction_type_id<>42
    and to_char(mmt.transaction_source_id)=mtrh.request_number
--    and mtrh.header_id=mtrl.header_id
    and mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and mmt.distribution_account_id=gcc.code_combination_id(+)
     and mmt.transaction_id=lt.transaction_id(+)
    and mmt.inventory_item_id=lt.inventory_item_id(+)
    and mmt.organization_id=lt.organization_id(+)
    and mmt.organization_id=ood.organization_id
--    and ood.legal_entity=23279
--    and ood.organization_code='SCI'
--    and gcc.segment2 like '%6HI%'
--    and mmt.organization_id=101
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ()
--    and trunc(mmt.transaction_date) between '01-JUN-15' and '30-JUN-15'
--    and (mmt.subinventory_code  like 'AKC%VEHICL%')-- or mmt.transfer_subinventory like 'AKC%VEHICL%')
--    and mmt.transaction_quantity>0
--    and mmt.transaction_source_id in (5288788)
--    and mmt.transaction_type_id=104 
--    and mmt.transaction_id in ()
--    and gcc.segment1(+)='2300'
--    and gcc.segment2(+)='OPTRK'
--       and gcc.segment3(+)='2050103' 
--    and rownum<10


