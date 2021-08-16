select
    mmt.transaction_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description,
    mmt.SUBINVENTORY_CODE,
    mc.segment1 Item_category,
    mc.segment2 Item_type,
    nvl(mmt.primary_quantity,0) Qty,
    apps.fnc_get_item_cost(msi.organization_id,msi.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) Item_Cost    
from
    inv.mtl_material_transactions mmt,
    inv.mtl_txn_source_types mtst,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc
where
    mtst.transaction_source_type_id=4
    and msi.organization_id=606
    and mmt.transaction_source_type_id=mtst.transaction_source_type_id
    and trunc(mmt.transaction_date) between '01-JUN-2014' and '30-JUN-2014'
    and mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and msi.organization_id=mic.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and mic.category_id=mc.category_id
--    and mc.segment1 in ('INDIRECT MATERIAL')
--    and mc.segment1 in ('MECHANICAL')
--    and (mc.segment2 like '%DISC%' or mc.segment2 like '%BLAD%')
--    and mc.segment2 in ('POLISHING PAD')
--    and mc.segment2 in ('ABRASIVE',
--'BLADE',
--'DISC',
--'GRINDING PLATE',
--'GRINDING WHEEL',
--'POLISHING PAD'
--) 
--    and rownum<10    