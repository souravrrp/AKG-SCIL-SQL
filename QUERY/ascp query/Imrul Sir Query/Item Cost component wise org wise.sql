select
    gps.calendar_code,
    gps.period_code,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description Item_Description,
    mc.segment1 Item_category,
    mc.segment2 Item_type,
    msi.primary_uom_code,
    msi.organization_id,
    ood.organization_code,
    ccm.COST_CMPNTCLS_CODE,
    sum(nvl(cst.cmpnt_cost,0)) Component_Cost
from
    apps.CM_CMPT_DTL_VW cst,
    apps.CM_CMPT_MST_B ccm,
    gmf.gmf_period_statuses gps,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    --GPS.LEGAL_ENTITY_ID=23280
     gps.calendar_code='AKG2017'
    and gps.period_code='6'
    and cst.period_id=gps.period_id
    and cst.cost_cmpntcls_id=ccm.cost_cmpntcls_id
    and cst.inventory_item_id=msi.inventory_item_id
    and cst.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and cst.organization_id=ood.organization_id
    and ood.operating_unit=83
--    and ood.organization_code in ('SCI')
--    and cst.organization_id=101
    --and mc.segment1 in ('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS','PROCESS SCRAP','GENERAL SCRAP')
--    and mc.segment1 in ('FINISH GOODS')
--    and mc.segment1 in ('CIVIL','ELECTRICAL','IT','LAB AND CHEMICAL','MECHANICAL','PRINTING AND STATIONARY','PRODUCTION','TOOLS')
--    and mc.segment1 in ('WIP')
--    and mc.segment1 in ('INGREDIENT','INDIRECT MATERIAL')
--    and mc.segment2 like '%SCRAP%'
--    and msi.inventory_item_id in (343380)
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('COVR.PLST.0014',
'COVR.PLST.0015',
'COVR.PLST.0017',
'COVR.PLST.0052',
'COVR.PLST.0018',
'COVR.PLST.0032',
'COVR.PLST.0021',
'COVR.PLST.0022',
'COVR.PLST.0016')
--and msi.segment1 like '%COVR%'
--    and msi.segment1 like 'CP%'
--    and ood.operating_unit=605
--    and rownum<10  
group by
    gps.calendar_code,
    gps.period_code,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    mc.segment1,
    mc.segment2,
    msi.primary_uom_code,
    msi.organization_id,
    ood.organization_code,
  ccm.COST_CMPNTCLS_CODE