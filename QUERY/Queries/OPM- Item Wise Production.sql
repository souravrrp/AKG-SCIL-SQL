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
   WHERE     a.organization_id = 99
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id
         and rt.routing_no='CAST PIECE FORMATION'
         and TO_CHAR (TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'), 'DD-MON-YY')=:PROD_DATE
GROUP BY a.organization_id,
         ood.organization_code,
         a.batch_no,
         a.attribute4,
         a.actual_start_date,
         a.batch_status,
         a.actual_cmplt_date,
         rt.routing_no,
         a.BATCH_CLOSE_DATE
ORDER BY 4 DESC



SELECT PRODUCTION_DATE,
         TO_CHAR (PRODUCTION_DATE, 'MON-YY') AS PERIOD,
--         BATCH_NO,
         CONCATENATED_SEGMENTS,
--         LOT_NUMBER,
         SUM (TRANS_QTY) TXN_QTY
    FROM apps.xxAKG_CER_OPM_BATCH_INFO
   WHERE     
          process = 'CAST PIECE FORMATION'--'KILN LOADING AND SORTING'---'SPRAY'--'FINISHING & INSPECTION'--'DRYING'
         AND 
--         LINE_TYPE_IND = -1     -- Ingredient
         LINE_TYPE_IND = 1    ---Product
--        LINE_TYPE_IND = 2     --By Product
--         AND ITEM_TYPE IN ('GP COIL - NOF', 'GP COIL - CGL')
        and PRODUCTION_DATE between '01-NOV-2013' and '30-NOV-2013'
--        and batch_no=:batch_no
GROUP BY PRODUCTION_DATE,
--         BATCH_NO,
         CONCATENATED_SEGMENTS--,
--         LOT_NUMBER
 order by 1,3
