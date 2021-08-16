select concatenated_segments ITEM,sum(primary_quantity*item_cost) VALUE from (
/* Formatted on 7/22/2013 3:33:10 PM (QP5 v5.163.1008.3004) */
  SELECT msi.concatenated_segments,
         --    msi.description,
         --    mic.segment1  catg ,
         --    mic.segment2 as item_type ,
         --    gpb.organization_id,
         --    gpb.subinventory_code,
         --    gpb.lot_number ,
         --    msi.primary_uom_code,msi.secondary_uom_code,
         SUM (NVL (gpb.primary_quantity, 0)) primary_quantity,
         SUM (NVL (gpb.secondary_quantity, 0)) sec_quantity,
         apps.fnc_get_item_cost (gpb.organization_id,
                                 msi.inventory_item_id,
                                 TO_CHAR (:P_DATE, 'MON-RR'))
            AS item_cost
    --,muc.conversion_rate * nvl(sum(gpb.secondary_quantity),0)/1000  as mtn_qty
    FROM apps.gmf_period_balances gpb,
         apps.org_acct_periods oap,
         apps.mtl_system_items_kfv msi,
         apps.mtl_item_categories_v mic,
         apps.mtl_uom_conversions muc
   WHERE     gpb.acct_period_id = oap.acct_period_id
         AND oap.period_year = 2013
         AND oap.period_num = 6
         AND gpb.organization_id 
--             in(94,95,96,97,98,188,464,125,124,123)
             IN (91,92,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,444,484,524)     --SCIL
--             in (100,201,365,424,425)       --RMC
         --and gpb.organization_id IN (select organization_id from apps.mtl_parameters where organization_code  like  'DL%' or organization_code ='AKS')  --  in(94,95,96,97,98,188,125,124,123)-- IN (select organization_id from apps.mtl_parameters where organization_code  like  'DL%' or organization_code ='AKS')
         AND msi.inventory_item_id = gpb.inventory_item_id
         AND msi.organization_id = gpb.organization_id
         AND mic.inventory_item_id = gpb.inventory_item_id
         AND mic.organization_id = gpb.organization_id
         AND muc.inventory_item_id(+) = msi.inventory_item_id
         AND mic.category_set_id = 1
--         AND NVL(mic.segment1,'X') IN ('INGREDIENT')    --('FINISH GOODS')
--        AND NVL(mic.segment1,'X') NOT IN ('INGREDIENT')    --('FINISH GOODS')
--         AND NVL(mic.segment1,'X') NOT IN ('FINISH GOODS')
-- AND mic.segment2 like '%REWINDING%'
-- and  substr(msi.concatenated_segments ,1,4)  in ('CISN','CISC','GPSC','GPSN')
--and mic.segment1   ='WIP' --in('WIP','FINISH GOODS')  -- ('INGREDIENT','INDIRECT MATERIAL')--,'WIP','FINISH GOODS')   --,'GENERAL SCRAP','PROCESS SCRAP')
--and  mic.segment2   LIKE '%CI SHEET%'  -- in ('GP COIL - NOF','GP COIL - CGL')
 and msi.concatenated_segments in ('CMNT.SBLK.0001')
GROUP BY msi.concatenated_segments,
         --        mic.segment1,
         gpb.organization_id,
         msi.inventory_item_id                                             --,
--        gpb.subinventory_code,
--        mic.segment2,
--        muc.conversion_rate,
--        msi.primary_uom_code,
--        msi.secondary_uom_code,
--        gpb.lot_number ,
--        msi.description
) group by concatenated_segments
order by concatenated_segments;



select distinct segment1 from apps.mtl_item_categories_v;