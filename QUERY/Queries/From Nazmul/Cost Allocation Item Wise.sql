SELECT   
    a.organization_id, ood.organization_code,
    a.batch_no, a.batch_id,
    --    a.batch_status,
    DECODE(a.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,
    msi.segment1||'.'||msi.segment2||'.'||segment3 Item_code,    
    nvl(b.actual_qty,0) Actual_Qty,
    nvl(cost_alloc,0) Cost_Alloc
--    sum(nvl(COST_ALLOC,0)) Cost_alloc
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt,
         inv.mtl_system_items_b msi
   WHERE
         ood.legal_entity=23279     
--         a.organization_id in (99,606)--= 606
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         and b.inventory_item_id=msi.inventory_item_id
         and b.organization_id=msi.organization_id
         AND a.routing_id = rt.routing_id 
       and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='JUN-14'
       and a.batch_status<>-1
       and b.line_type=1
     --and a.batch_id in 
 --and a.batch_no in ()
GROUP BY         a.organization_id,ood.organization_code,a.batch_no,a.batch_id,a.batch_status,msi.segment1||'.'||msi.segment2||'.'||segment3,    
    nvl(b.actual_qty,0),nvl(cost_alloc,0)
--having round(1-sum(nvl(COST_ALLOC,0)),3)<>0
