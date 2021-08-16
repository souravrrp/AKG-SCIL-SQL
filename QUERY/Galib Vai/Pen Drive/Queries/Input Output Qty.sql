select * from (
/* Formatted on 11/17/2013 6:09:49 PM (QP5 v5.136.908.31019) */
/*  Batch Detail*/
  SELECT rt.routing_no,
         a.organization_id,
         ood.organization_code,
         a.batch_no,
         a.actual_start_date,
         TO_CHAR (a.actual_start_date, 'MON-YY') Period,
         TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS') AS Production_Date,
         TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')
            AS Production_PERIOD,
         DECODE (a.batch_status,
                 1, 'Pending',
                 2, 'WIP',
                 3, 'Completed',
                 4, 'Closed',
                 -1, 'Cancelled',
                 'Others')
            AS Batch_status,
         a.batch_close_date,
         a.actual_cmplt_date,
         SUM (DECODE (b.line_type, -1, b.actual_qty)) AS ING,
         SUM (DECODE (b.line_type, 1, b.actual_qty)) AS Prod,
         SUM (DECODE (b.line_type, 2, b.actual_qty)) AS BY_prod
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE   
--          a.organization_id = 99
--        and 
        ood.legal_entity=23279
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id
--         and a.batch_no in (19931)
--         and rt.routing_no='CAST PIECE FORMATION'
--         and to_char(trunc(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS')),'MON-YY') ='JUL-14'
         and trunc(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS')) between '01-SEP-2014' and '30-SEP-2014'
GROUP BY a.organization_id,
         ood.organization_code,
         a.batch_no,
         a.attribute4,
         a.actual_start_date,
         a.batch_status,
         a.actual_cmplt_date,
         rt.routing_no,
         a.BATCH_CLOSE_DATE
--ORDER BY 4 DESC
 )
 where
    BATCH_STATUS<>'Cancelled'
--    and (ING=0 or PROD=0)
