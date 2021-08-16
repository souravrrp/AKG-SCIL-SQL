SELECT   a.batch_no, a.batch_id,sum(nvl(COST_ALLOC,0))
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE     
         a.organization_id = 99
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id 
       and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='JUL-14'
       and a.batch_no in (21660)
--       and a.batch_id=474134
GROUP BY         a.batch_no,a.batch_id
--having round(1-sum(nvl(COST_ALLOC,0)),3)<>0
