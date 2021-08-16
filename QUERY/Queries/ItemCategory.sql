select
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    ood.organization_code,
    mc.segment1,
    mc.segment2
from
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    msi.organization_id=ood.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
--    and ood.organization_code='DTN'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('SNKS.CHCL.0050')
--    and msi.segment1='SERV'  
--    and mc.segment2='MILK'  
