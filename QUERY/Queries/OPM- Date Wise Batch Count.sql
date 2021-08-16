select
--    *
    ood.legal_entity,
    grb.ROUTING_NO Process,
    ood.organization_code, 
    gbh.batch_id,
    gbh.batch_no,
    DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,
    TO_DATE (gbh.attribute4, 'RRRR/MM/DD HH24:MI:SS') Production_date,
    gbh.ACTUAL_START_DATE,
    gbh.ACTUAL_CMPLT_DATE,
    gbh.BATCH_CLOSE_DATE
from
    gme.gme_batch_header gbh,
    apps.org_organization_definitions ood,
    apps.gmd_routings_b grb
where
--    ood.legal_entity=23279
--    and gbh.organization_id=99
--    and 
    gbh.organization_id=ood.organization_id
    and gbh.routing_id=grb.routing_id
    and gbh.organization_id=grb.owner_organization_id
    and to_char(TO_DATE (gbh.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='JAN-15'
--    rownum<10