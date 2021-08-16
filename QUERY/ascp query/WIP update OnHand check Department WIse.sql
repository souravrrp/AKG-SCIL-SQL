select * from (
select  routing_no,Item,description,SUBINVENTORY,DTL_UM, sum(nvl(PLAN_QTY,0)) pq, sum(nvl(ACTUAL_QTY,0)) aq, primary_uom_code, on_hand,  on_hand - (sum(nvl(PLAN_QTY,0)) -sum(nvl(ACTUAL_QTY,0)))  SHORT_EXCESS  from (
/* Formatted on 6/19/2016 3:57:27 PM (QP5 v5.163.1008.3004) */
SELECT grb.routing_no,
gbh.batch_no, gbh.batch_status,
msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3 Item,msi.description,
       gmd.SUBINVENTORY,
--       msi.LOT_CONTROL_CODE, 
       --moqd.LOT_NUMBER,
       gmd.DTL_UM, gmd.PLAN_QTY, gmd.ACTUAL_QTY, msi.primary_uom_code
       , SUM (moqd.PRIMARY_TRANSACTION_QUANTITY) on_hand,
        SUM (moqd.PRIMARY_TRANSACTION_QUANTITY) - (gmd.PLAN_QTY-gmd.ACTUAL_QTY) Short_Excess
  FROM GME.GME_BATCH_HEADER gbh,
       gme.gme_material_details gmd, gmd.gmd_routings_b grb,
       inv.mtl_system_items_b msi,
       inv.mtl_onhand_quantities_detail moqd
WHERE     gmd.organization_id = 99
       AND gmd.line_type = -1 and gbh.batch_status>=2
       AND gmd.organization_id = msi.organization_id
       AND gmd.inventory_item_id = msi.inventory_item_id
       AND gbh.organization_id = msi.organization_id
       AND gbh.batch_id = GMD.batch_id
       AND TO_CHAR (gbh.actual_start_date, 'DD-MON-YYYY') = '24-AUG-2016'
--       AND gbh.actual_start_date>= '01-AUG-2016'
       AND moqd.inventory_item_id(+) = msi.inventory_item_id
       AND moqd.organization_id(+) = msi.organization_id
       AND gmd.SUBINVENTORY = moqd.SUBINVENTORY_code(+)
       and grb.routing_id=gbh.routing_id
--       and gbh.batch_no='81610'   
       --and grb.routing_no like 'CAST'-- and msi.segment1 like 'UW%'
group by grb.routing_no,gbh.batch_no,gbh.batch_status,msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3,msi.description,
       gmd.SUBINVENTORY,
--       msi.LOT_CONTROL_CODE, 
       gmd.DTL_UM,
       --moqd.LOT_NUMBER,
       msi.primary_uom_code,gmd.PLAN_QTY, gmd.ACTUAL_QTY
having  nvl(gmd.PLAN_QTY,0)> nvl(gmd.ACTUAL_QTY,0) 
) group by routing_no,Item,description, SUBINVENTORY,DTL_UM, primary_uom_code,on_hand
--having sum(nvl(PLAN_QTY,0)) -sum(nvl(ACTUAL_QTY,0)) -on_hand>=0
) where nvl(SHORT_EXCESS,-1)<0
