SELECT   a.organization_id,a.batch_no, a.batch_id,a.batch_status,sum(nvl(COST_ALLOC,0)) SUM_CST_ALLOC
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE     
         ood.legal_entity=23279
--         and a.organization_id=ood.organization_id
--         a.organization_id in (99,606)--= 606
         AND a.batch_id = b.batch_id
--         and a.batch_no=18300
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id 
       and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='JUN-14'
       and a.batch_status<>-1
     --and a.batch_id=496589
GROUP BY         a.organization_id,a.batch_no,a.batch_id,a.batch_status
--having round(1-sum(nvl(COST_ALLOC,0)),3)<>0

