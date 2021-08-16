select
--    *
--    ood.organization_code,
    gam.alloc_code,
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
--    msi.description Item_Description,
    sum(nvl(FIXED_PERCENT,0)) Alloc_Percent
from
--    apps.gl_aloc_exp gae,
    apps.gl_aloc_mst gam,
    apps.gl_aloc_bas gab,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
    gam.legal_entity_id=23279
    and gam.alloc_id=gab.alloc_id
    and gab.inventory_item_id=msi.inventory_item_id
    and gab.organization_id=msi.organization_id
    and gab.organization_id=ood.organization_id
--    and ood.operating_unit=87
--    rownum<10    
group by
--    ood.organization_code,
    gam.alloc_code--,
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
--    msi.description