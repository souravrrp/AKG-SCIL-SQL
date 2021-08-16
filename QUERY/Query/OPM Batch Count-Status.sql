select 
    ood.legal_entity,
     ood.organization_code,
     gbh.BATCH_NO,
     DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,  
     count(*) COUNT
from 
    GME.GME_BATCH_HEADER gbh,
    apps.org_organization_definitions ood 
where 
--    ood.legal_entity=23279
--    and 
    gbh.organization_id=ood.organization_id 
    and trunc(to_date(gbh.attribute4,'YYYY/MM/DD HH24:MI:SS')) between '01-NOV-2014' and '30-NOV-2014'  
--    BATCH_CLOSE_DATE is NULL and 
--    BATCH_STATUS<>-1
--    and gbh.BATCH_NO='26023'
group by
    ood.legal_entity,
    ood.ORGANIZATION_code,
    gbh.BATCH_NO, 
    gbh.BATCH_STATUS
order by
    ood.ORGANIZATION_code,
    gbh.BATCH_NO, 
    gbh.BATCH_STATUS


-----------------------------------------
--** Accross The Period**--
-----------------------------------------
select
--    *
    gr.routing_no PROCESS,
    ood.organization_code,
     DECODE (gbh.batch_status,
                 1, 'Pending',
                 2, 'WIP',
                 3, 'Completed',
                 4, 'Closed',
                 -1, 'Cancelled',
                 'Others')
            AS Batch_status,
    gbh.batch_no,
    trunc(gbh.ACTUAL_START_DATE) ACTUAL_START_DATE,
    trunc(gbh.ACTUAL_CMPLT_DATE) ACTUAL_CMPLT_DATE,
    TRUNC(gbh.BATCH_CLOSE_DATE) BATCH_CLOSE_DATE,
    trunc(gmd.material_requirement_date) MATERIAL_REQUIREMENT_DATE
--    count(gbh.batch_id) count 
from 
    GME.GME_BATCH_HEADER gbh,
    gmd.gmd_routings_b gr,
    apps.org_organization_definitions ood,
    gme.gme_material_details gmd
where
    gbh.routing_id=gr.routing_id
    and gbh.organization_id=ood.organization_id
    and ood.ORGANIZATION_ID in (99,100,101,113,201,365,444,606)
    and gbh.batch_id=gmd.batch_id
    and trunc(to_date(gbh.attribute4,'RRRR/MM/DD HH24:MI:SS')) between '01-NOV-2013' and '30-NOV-2013' 
    and (
        TRUNC(gbh.ACTUAL_START_DATE)>  '30-NOV-2013' or
        trunc(gbh.ACTUAL_CMPLT_DATE)>  '30-NOV-2013' or
        TRUNC(gbh.BATCH_CLOSE_DATE) > '30-NOV-2013' --or
--        trunc(gmd.material_requirement_date) >'30-NOV-2013'
        )
group by
    gr.routing_no,
    ood.organization_code,
    gbh.batch_status,
    gbh.batch_no,
    trunc(gbh.ACTUAL_START_DATE),
    trunc(gbh.ACTUAL_CMPLT_DATE),
    TRUNC(gbh.BATCH_CLOSE_DATE),
    trunc(gmd.material_requirement_date)
order by
    gr.routing_no,
    ood.organization_code,
    gbh.batch_no;        
    