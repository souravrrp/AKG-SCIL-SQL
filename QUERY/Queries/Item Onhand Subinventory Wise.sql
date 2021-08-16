select 
--    *
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description Item_Desc,
    mic.segment1 Item_Category,
    mic.segment2 Item_type,
    ood.ORGANIZATION_CODE,
    mmt.SUBINVENTORY_CODE,
--    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account,    
    sum(nvl(mmt.transaction_quantity,0)) Qty 
from 
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    apps.mtl_item_categories_v mic,
    apps.org_organization_definitions ood--,
--    gl.gl_code_combinations gcc 
where 
--    ood.SET_OF_BOOKS_ID=2025
    ood.operating_unit=85
    and msi.organization_id=ood.organization_id
    and msi.organization_id=mic.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and msi.inventory_item_id=mmt.inventory_item_id
  -- and msi.organization_id=99
--    and msi.INVENTORY_ITEM_ID=24409
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='DRCT.CLNK.0001'
--    and mmt.SUBINVENTORY_CODE='CLINKER'
    and ood.organization_code='CER'
--    and mic.segment1='INGREDIENT'
    and trunc(mmt.transaction_date) <trunc(sysdate)+1
--    and rownum<10
group by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    mic.segment1,mic.segment2,
    ood.ORGANIZATION_CODE,
    mmt.SUBINVENTORY_CODE
having
    sum(nvl(mmt.transaction_quantity,0))<>0    
    
    