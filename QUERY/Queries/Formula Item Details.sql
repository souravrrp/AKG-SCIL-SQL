SELECT SECONDARY_INVENTORY_NAME  FROM APPS.MTL_SECONDARY_INVENTORIES_FK_V WHERE SECONDARY_INVENTORY_NAME ='CER-SP FLR'


select
    *
from
    gme.GME_MATERIAL_DETAILS
where    
    LINE_TYPE = -1
--AND :GME_MATERIAL_DETAILS.INVENTORY_ITEM_ID in ('22895','22906','22921',
--'22928','22931','22952','22995','22935','22946','23137')
AND ORGANIZATION_ID=99
and batch_id=652573


select
    *
from
    apps.FM_FORM_MST
where
    formula_no in ('RPRT.BOPT.0001','RPRT.CDST.0001','RPRT.HDST.0001','RPRT.LEAF.0001','RPRT.TBAG.0001')
    and formula_vers=1
--    rownum<10    


select
--    count(distinct formulaline_id)
--    distinct formulaline_id
    ood.organization_code,
    ffm.formula_no,
    ffm.formula_vers,
    fmd.line_type,
    mc.segment1,
    mc.segment2,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    fmd.ITEM_UM,
    fmd.qty,
    fmd.*
from
    apps.FM_FORM_MST ffm,
    apps.FM_MATL_DTL fmd,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    ffm.formula_id=fmd.formula_id
    and fmd.inventory_item_id=msi.inventory_item_id
    and fmd.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and msi.organization_id=ood.organization_id
    and ood.legal_entity=23279
    and ood.operating_unit=83
--    and ood.organization_code='MRB'
    and ffm.formula_no like '%FORMULA FOR  WB SOFIA A PACK%'
--    and ffm.formula_id in (11403,
--11401,
--11402,
--11400,
--11404)
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('PACK.MAT0.0158')
--    and trunc(fmd.LAST_UPDATE_DATE) >='22-JAN-2015'
--    and msi.organization_id=688
--order by
--    formula_no,
--    line_type    
    
    
    
     in 
    (select
    formula_id
from
    apps.gmd_recipes
where
    routing_id in 
    (select
    routing_id
from
    gmd.gmd_routings_b
where
    regexp_like(routing_no,'(SLIP|GLAZE|MIXTURE)')))
    and fmd.line_type=-1
--    rownum<10    


select
    *
from
    gme.gme_batch_header
where
    organization_id=99
    and batch_no=23664
    


select *
from
    apps.org_organization_definitions ood
where
    ood.organization_code='SPL'        
    
select
    *
from
    gmd.gmd_routings_b
where
--    regexp_like(routing_no,'(SLIP|GLAZE|MIXTURE)')
    owner_organization_id=94
--    rownum<10        



select *
from
    apps.gmd_resources
where
    rownum<10    


select *
from
    apps.CR_RSRC_MST_VL
--where
--    rownum<10    




select
    *
from
    apps.gmd_recipes
where
    routing_id in (select
    routing_id
from
    gmd.gmd_routings_b
where
    owner_organization_id=94
--    regexp_like(routing_no,'(SLIP|GLAZE|MIXTURE)')
    )
--    rownum<10    



select
    gbh.batch_no,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description,
    mc.segment1,
    mc.segment2
from
    gme.gme_batch_header gbh,
    gme.gme_material_details gmd,
    gmd.gmd_routings_b gr,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc
where
    gbh.batch_id=gmd.batch_id
    and gbh.routing_id=gr.routing_id
    and regexp_like(gr.routing_no,'(SLIP|GLAZE|MIXTURE)')
    and msi.inventory_item_id=gmd.inventory_item_id
    and msi.organization_id=gmd.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and gmd.organization_id=99
    and gbh.batch_no=23664
    and gmd.line_type=-1
--    rownum<10    