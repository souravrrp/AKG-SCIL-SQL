    
select
    mmt.transaction_id,
    mmt.reason_id,
    mmt.transaction_date,
    mtt.transaction_type_name,
    mtrh.request_number mo_number,
    mtrh.created_by,
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
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 dist_code_combination--,
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_types mtt,
    inv.mtl_txn_request_headers mtrh,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    gl.gl_code_combinations gcc,
    inv.mtl_transaction_lot_numbers lt,
    apps.org_organization_definitions ood
where
--    mmt.transaction_id in (47280813)
--    and 
    mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transaction_source_type_id=4
--    and mmt.transaction_type_id=64
    and to_char(mmt.transaction_source_id)=mtrh.request_number
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
    and ood.legal_entity=23279
--    and gcc.segment2 like '%6HI%'
    and mmt.organization_id=99
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.CLAY.0001',
'DRCT.CLAY.0007',
'DRCT.CLAY.0004',
'DRCT.CLAY.0005',
'DRCT.CLAY.0002',
'DRCT.CLAY.0006',
'DRCT.CLAY.0008',
'DRCT.CLAY.0009',
'DRCT.CLAY.0011',
'DRCT.SODI.0003',
'DRCT.PWDR.0001',
'DRCT.PWDR.0005',
'DRCT.PWDR.0003',
'DRCT.REMB.0001',
'DRCT.SODI.0001',
'DRCT.HEXA.0001',
'DRCT.SAND.0001',
'DRCT.PWDR.0004',
'DRCT.DMND.0001',
'SCRP.CAST.0001',
'DRCT.CLAY.0016',
'DRCT.CLAY.0015',
'DRCT.CLAY.0012',
'DRCT.CARB.0001')
    and trunc(mmt.transaction_date) between '19-MAY-15' and '19-MAY-15'
    and mmt.subinventory_code ='CER-RM STR'
--    and mmt.transaction_source_id in (4716323)
--    and mmt.transaction_type_id=104 
--    and mmt.transaction_id in (49342744)
--    and gcc.segment1(+)='2300'
--    and gcc.segment2(+)='OPTRK'
--       and gcc.segment3(+)='4030806' 




select
--    *
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 acc_code_combination,
    code_combination_id
from
    gl.gl_code_combinations gcc
where
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 in ('1160.PRJCT.2030102.9999.00',
'1160.PRJCT.2030102.9999.00',
'1160.PRJCT.2030102.9999.00',
'1160.PRJCT.2030102.9999.00',
'1160.PRJCT.2030102.9999.00')    
    
select
--    *
    DISTRIBUTION_ACCOUNT_ID
from
update
    inv.mtl_material_transactions
set DISTRIBUTION_ACCOUNT_ID=164554    
where
    transaction_id in (37069319,
37933566,
37916022,
37914112,
36745070)    