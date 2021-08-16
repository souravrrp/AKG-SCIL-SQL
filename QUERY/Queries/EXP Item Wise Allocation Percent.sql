select
    *
from
    apps.gl_aloc_exp gae
where
    rownum<10    


select
    gam.alloc_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description Item_Description,
    sum(gab.fixed_percent) Alloc_Percent
from
    apps.gl_aloc_mst gam,
    apps.gl_aloc_bas gab,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
    gam.alloc_id=gab.alloc_id
    and gab.inventory_item_id=msi.inventory_item_id
    and gab.organization_id=msi.organization_id
    and gab.organization_id=ood.organization_id
    and ood.operating_unit=85
group by
    gam.alloc_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description
--having sum(gab.fixed_percent)<>0




select
    gam.alloc_id,
    gam.alloc_code,
    gam.alloc_desc
from
    apps.gl_aloc_mst gam
where
    gam.legal_entity_id=23279
--    and rownum<10
    
select
--    *
    gam.alloc_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description Item_Description,
    sum(gab.fixed_percent) Alloc_Proportion,
    sum(gai.amount)
from
    apps.gl_aloc_mst gam,
    apps.gl_aloc_bas gab,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    apps.gl_aloc_inp gai
where
    gam.alloc_id=gab.alloc_id
    and gam.alloc_id=gai.alloc_id
    and gai.calendar_code='AKG2014'
    and gai.period_code=4
    and gab.inventory_item_id=msi.inventory_item_id
    and gab.organization_id=msi.organization_id
    and gab.organization_id=ood.organization_id
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('CMNT.OBLK.0001','CMNT.OBAG.0001')
    and ood.operating_unit=85
group by
    gam.alloc_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description    
    
    
select
    *
from
    apps.GL_ALOC_INP gai--,
--    apps.GL_ALOC_dtl gad
where
    rownum<10             