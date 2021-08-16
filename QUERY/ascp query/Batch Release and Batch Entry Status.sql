select aa.*,bb.completed, cc.pending_WIP_Cancel from 
(SELECT 
grb.routing_no, count(*) released
  FROM GME.GME_BATCH_HEADER gbh,
       gmd.gmd_routings_b grb
WHERE     gbh.organization_id = 99
      AND TO_CHAR (gbh.actual_start_date, 'DD-MON-YYYY') = :pdate
       and gbh.routing_id=grb.routing_id
       and gbh.created_by=10518 and gbh.batch_status>=2
group by 
grb.routing_no) aa,
(SELECT 
grb.routing_no, count(*) completed
  FROM GME.GME_BATCH_HEADER gbh,
       gmd.gmd_routings_b grb
WHERE     gbh.organization_id = 99
      AND TO_CHAR (gbh.actual_start_date, 'DD-MON-YYYY') = :pdate 
       and gbh.routing_id=grb.routing_id and gbh.batch_status>2
group by 
grb.routing_no) bb,
(SELECT 
grb.routing_no, count(*) pending_WIP_Cancel
  FROM GME.GME_BATCH_HEADER gbh,
       gmd.gmd_routings_b grb
WHERE     gbh.organization_id = 99
      AND TO_CHAR (gbh.actual_start_date, 'DD-MON-YYYY') = :pdate --e.g '21-JUL-2016'
       and gbh.routing_id=grb.routing_id and gbh.batch_status<=2
group by 
grb.routing_no) cc
where aa.routing_no=cc.routing_no(+) and aa.routing_no=bb.routing_no(+)