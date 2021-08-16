SELECT   ood.legal_entity,ood.organization_code,a.batch_no, a.batch_id,DECODE(a.batch_status,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,sum(nvl(COST_ALLOC,0)) SUM_CST_ALLOC
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE     
--         ood.legal_entity=23279
--         and a.organization_id=ood.organization_id
--         and 
--            a.organization_id =99
--         AND 
         a.batch_id = b.batch_id
--             and a.batch_no in (52749)
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id 
       and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='SEP-15'
--        and trunc(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS')) between '01-DEC-2014' and '31-DEC-2014'
       and a.batch_status<>-1
     --and a.batch_id=496589
GROUP BY         ood.legal_entity,ood.organization_code,a.batch_no,a.batch_id,a.batch_status
--having round(1-sum(nvl(COST_ALLOC,0)),3)<>0

