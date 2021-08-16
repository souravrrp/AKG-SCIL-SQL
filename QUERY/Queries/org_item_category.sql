select
    *
from
    apps.org_organization_definitions
where
    organization_code='DRP'    
    
    
select
    ood.organization_id,
    ood.organization_code,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description,
    mc.segment1 item_category,
    mc.segment2 item_type
from
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and msi.organization_id=ood.organization_id
    and mic.category_id=mc.category_id
--        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 like  ('ANGL.%.%')
        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in  ('GENL.GENL.2036',
'SERV.REFL.0007',
'SERV.REFL.0004',
'SERV.REFL.0006',
'SERV.REFL.0008',
'SERV.REFL.0003',
'SERV.REFL.0009',
'SERV.REPA.0007',
'SERV.REPA.0008',
'SERV.REPA.0009',
'SERV.REPA.0019')
--    and (msi.segment2 like ('VER%') or msi.segment2 like ('VRB%') or msi.segment2 like ('VRS%'))
--    and mc.segment1 in ('TRADING')
--    and mc.segment2 like 'GIFT ITEM%'
--    and msi.description like '%Angelina%'
--    and ood.organization_code in ('AKS')
--    and ood.operating_unit=82
    and ood.legal_entity=23280
    and mic.category_set_id=1
order by  msi.description,msi.segment1||'.'||msi.segment2||'.'||msi.segment3
    
    GIFT ITEM-POWDER
            