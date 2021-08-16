  select
    pbal.*,
    cstcmpnt.COST_CMPNTCLS_CODE,
    cstcmpnt.COMPONENT_COST
  from
  (SELECT 
            msi.inventory_item_id,
            msi.concatenated_segments,
             msi.description,
             mic.segment1  catg ,
             mic.segment2 as item_type ,
             gpb.organization_id,
        ood.organization_code,
             gpb.subinventory_code,
             gpb.lot_number ,
             msi.primary_uom_code,msi.secondary_uom_code,
         SUM (NVL (gpb.primary_quantity, 0)) primary_quantity,
         SUM (NVL (gpb.secondary_quantity, 0)) sec_quantity,
         apps.fnc_get_item_cost (gpb.organization_id,
                                 msi.inventory_item_id,
                                 oap.period_name)
            AS item_cost
    ,muc.conversion_rate * nvl(sum(gpb.secondary_quantity),0)/1000  as mtn_qty
    FROM apps.gmf_period_balances gpb,
         apps.org_acct_periods oap,
         apps.mtl_system_items_kfv msi,
         apps.mtl_item_categories_v mic,
         apps.mtl_uom_conversions muc,
         apps.org_organization_definitions ood
   WHERE     gpb.acct_period_id = oap.acct_period_id
         AND oap.period_year = :period_year
         AND oap.period_num = :period_num
         and ood.legal_entity=:legal_entity
         and ood.operating_unit=:operating_unit
         and ood.organization_id=gpb.organization_id
--         AND gpb.organization_id 
--             in(94,95,96,97,98,188,464,125,124,123)
--             IN (91,92,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,444,484,524)     --SCIL
--             in (100,201,365,424,425)       --RMC
         --and gpb.organization_id IN (select organization_id from apps.mtl_parameters where organization_code  like  'DL%' or organization_code ='AKS')  --  in(94,95,96,97,98,188,125,124,123)-- IN (select organization_id from apps.mtl_parameters where organization_code  like  'DL%' or organization_code ='AKS')
         AND msi.inventory_item_id = gpb.inventory_item_id
         AND msi.organization_id = gpb.organization_id
         AND mic.inventory_item_id = gpb.inventory_item_id
         AND mic.organization_id = gpb.organization_id
         AND muc.inventory_item_id(+) = msi.inventory_item_id
         AND mic.category_set_id = 1
         and mic.segment1 in 
                                        ('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS')
--         and mic.segment2 in ('CANDY','GIFT ITEM-CANDY')
--         AND NVL(mic.segment1,'X') IN ('INGREDIENT')    --('FINISH GOODS')
--        AND NVL(mic.segment1,'X') NOT IN ('INGREDIENT')    --('FINISH GOODS')
--         AND NVL(mic.segment1,'X') NOT IN ('FINISH GOODS')
-- AND mic.segment2 like '%REWINDING%'
-- and  substr(msi.concatenated_segments ,1,4)  in ('CISN','CISC','GPSC','GPSN')
--and mic.segment1   ='WIP' --in('WIP','FINISH GOODS')  -- ('INGREDIENT','INDIRECT MATERIAL')--,'WIP','FINISH GOODS')   --,'GENERAL SCRAP','PROCESS SCRAP')
--and  mic.segment2   LIKE '%CI SHEET%'  -- in ('GP COIL - NOF','GP COIL - CGL')
-- and msi.concatenated_segments in ('CMNT.SBLK.0001')
--    and rownum<10
GROUP BY 
--            msi.inventory_item_id,
            msi.concatenated_segments,
                 mic.segment1,
         gpb.organization_id,
        ood.organization_code,
         msi.inventory_item_id,
        gpb.subinventory_code,
        mic.segment2,
        muc.conversion_rate,
        msi.primary_uom_code,
        msi.secondary_uom_code,
        gpb.lot_number ,
        msi.description,
        oap.period_name) pbal,
(select
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description Item_Description,
    mc.segment1 Item_category,
    mc.segment2 Item_type,
    msi.organization_id,
    ood.organization_code,
    ccm.COST_CMPNTCLS_CODE,
    sum(nvl(cst.cmpnt_cost,0)) Component_Cost
from
    apps.CM_CMPT_DTL_VW cst,
    gmf.CM_CMPT_MST_B ccm,
    gmf.gmf_period_statuses gps,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    GPS.LEGAL_ENTITY_ID=:legal_entity
    and gps.calendar_code='AKG'||:period_year
    and gps.period_code=:period_num
    and cst.period_id=gps.period_id
    and cst.cost_cmpntcls_id=ccm.cost_cmpntcls_id
    and cst.inventory_item_id=msi.inventory_item_id
    and cst.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and cst.organization_id=ood.organization_id
    and ood.operating_unit=:operating_unit
--    and cst.organization_id=606
    and mc.segment1 in 
                                ('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS')
--                                   ('FINISH GOODS','WIP')
--    and mc.segment1 in ('CIVIL','ELECTRICAL','IT','LAB AND CHEMICAL','MECHANICAL','PRINTING AND STATIONARY','PRODUCTION','TOOLS')
--    and mc.segment1 in ('W')
--    and mc.segment2 like '%SCRAP%'
--    and msi.inventory_item_id in ()
--    and ood.operating_unit=605
--    and rownum<10  
group by
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    mc.segment1,
    mc.segment2,
    msi.organization_id,
    ood.organization_code,
    ccm.COST_CMPNTCLS_CODE) cstcmpnt
where
    pbal.inventory_item_id=cstcmpnt.inventory_item_id
    and pbal.organization_id=cstcmpnt.organizATION_id    