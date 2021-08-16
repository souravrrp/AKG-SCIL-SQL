SELECT rt.routing_no,
         a.organization_id,
         ood.organization_code,
         a.batch_no,ffmb.formula_no,
         a.actual_start_date,
         TO_CHAR (a.actual_start_date, 'MON-YY') Period,
         TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS') AS Production_Date,
         TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY'),
         TO_CHAR (a.actual_start_date, 'DD-MON-YYYY')
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
         SUM (DECODE (b.line_type, -1, b.plan_qty)) AS ING,
         SUM (DECODE (b.line_type, 1, b.plan_qty)) AS Prod,
         SUM (DECODE (b.line_type, 2, b.plan_qty)) AS BY_prod,
         SUM (DECODE (b.line_type, -1, b.actual_qty)) AS ING,
         SUM (DECODE (b.line_type, 1, b.actual_qty)) AS Prod,
         SUM (DECODE (b.line_type, 2, b.actual_qty)) AS BY_prod
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt, apps.fm_form_mst_b ffmb
   WHERE     a.organization_id = 99
         --and TO_CHAR(a.actual_start_date,'MON-YY') ='OCT-13'-->='01-OCT-2013'
         --and to_char(a.actual_start_date,'DD-MON-YYYY')='29-AUG-2016'
         AND trunc (a.actual_start_date) between  '01-MAY-2017' and '01-MAY-2017'
         --and TO_CHAR(a.batch_close_date,'MON-YY') ='NOV-13'
         --and TO_CHAR(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'),'MON-YY') IN ('OCT-13')
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id
         and a.formula_id=ffmb.formula_id
       and rt.routing_NO='KILN'
--         and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'MON-YY')='OCT-13'
GROUP BY a.organization_id,
         ood.organization_code,
         a.batch_no,ffmb.formula_no,
         a.attribute4,
         a.actual_start_date,
         a.batch_status,
         a.actual_cmplt_date,
         rt.routing_no,
         a.BATCH_CLOSE_DATE,
         TO_CHAR (a.actual_start_date, 'DD-MON-YYYY')
--having SUM (DECODE (b.line_type, -1, b.actual_qty))<>0 and SUM (DECODE (b.line_type, 1, b.actual_qty))=0
ORDER BY 7 DESC

