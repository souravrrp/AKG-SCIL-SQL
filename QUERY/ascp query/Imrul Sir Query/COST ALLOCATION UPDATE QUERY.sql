select distinct  RT.ROUTING_NO,msi.segment1||'.'||msi.segment2||'.'||msi.segment3, gmd.SUBINVENTORY, GBH.BATCH_NO,
DECODE(GBH.BATCH_STATUS, 1, 'PENDING', 2, 'WIP', 3, 'COMPLETE', 4,'CLOSE') AS BATCH_STATUS,msi.LOT_CONTROL_CODE,gmd.cost_alloc
 from GME.GME_BATCH_HEADER gbh, gme.gme_material_details gmd,inv.mtl_system_items_b msi, apps.gmd_routings_b rt
where gmd.organization_id=99 and gmd.line_type=1
and gmd.organization_id=msi.organization_id and gmd.inventory_item_id=msi.inventory_item_id
and gbh.organization_id=msi.organization_id and gbh.batch_id=GMD.batch_id
AND GBH.ROUTING_ID = RT.ROUTING_ID
--AND GBH.BATCH_NO = 314946
AND RT.ROUTING_NO = 'REFIRE FOR KILN'
AND TRUNC(gbh.actual_start_date) BETWEEN '02-JUN-2017' AND '19-JUN-2017'
and gmd.cost_alloc !=1

   