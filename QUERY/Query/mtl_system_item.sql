select
    msi.inventory_item_id,
    ood.operating_unit,
    ood.organization_code,
    msi.organization_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    msi.attribute29 movement_status,
    msi.attribute11 Previous_Status_2,
    msi.ATTRIBUTE12 Previous_Status_3,
    msi.ATTRIBUTE13 Inventory_Status,
    msi.primary_uom_code,
    msi.secondary_uom_code,
    mc.segment1 item_category_segment1,
    mc.segment2 item_category_segment2
from
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc
where
    ood.legal_entity=23279
--    and ood.opera
    and msi.organization_id=ood.organization_id
--    and msi.inventory_item_id in (23970,24117,25698)
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ()     
--    and (msi.segment1 = 'CISC')
--    and msi.description like ('%Spong%')
    and ood.organization_code='CER'
    and msi.organization_id=mic.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and mic.category_id=mc.category_id
    and mic.category_set_id=1
--    and msi.organization_id not in (90,91,685)
--    and mc.segment1 in ('WIP')
--    and mc.segment2 like '%WB%'        
--    and msi.segment1 in ('WMLD')
--    and msi.segment3 in ('0550')
--    and regexp_like(mc.segment2,'STEEL|BILLET')
--    and msi.attribute29 like '%moving%'
--    and msi.item_type like 'NS%'
    and msi.INVENTORY_ITEM_STATUS_CODE='Active'
    and msi.organization_id not in (90,91)
--    and rownum<10