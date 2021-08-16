SELECT rt.routing_no,
         a.organization_id,
         ood.organization_code,
         a.batch_no,
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
         a.actual_start_date,
         a.actual_cmplt_date,
         a.batch_close_date,
         SUM (DECODE (b.line_type, -1, b.actual_qty)) AS ING,
         SUM (DECODE (b.line_type, 1, b.actual_qty)) AS Prod,
         SUM (DECODE (b.line_type, 2, b.actual_qty)) AS BY_prod
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE     
--        a.organization_id in(99,606)
        ood.legal_entity=23279
--        ood.operating_unit=85
--        and ood.organization_id=a.organization_id
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id
         and trunc(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS')) between '01-MAY-14' and '31-MAY-14'
         and a.batch_status<>-1
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

 

 

/* Formatted on 11/17/2013 6:10:14 PM (QP5 v5.136.908.31019) */

/*Period Batch Count*/
SELECT COUNT (a.batch_no)
  FROM apps.gme_batch_header a
 WHERE     a.organization_id IN (99)
       AND trunc(a.actual_start_date) >= '01-JAN-2014'
       AND trunc(a.actual_start_date) <= '31-JAN-2014'
 

 

-----------------

 

/* Formatted on 11/17/2013 6:10:25 PM (QP5 v5.136.908.31019) */
  SELECT PRODUCTION_DATE,
         TO_CHAR (PRODUCTION_DATE, 'MON-YY') AS PERIOD,
         BATCH_NO,
         CONCATENATED_SEGMENTS,
         LOT_NUMBER,
         SUM (TRANS_QTY)
    FROM apps.xxAKG_CER_OPM_BATCH_INFO
   WHERE     
          process = 'SPRAY'
         
   --AND  LINE_TYPE_IND = -1     ---- Ingredient
 --   AND LINE_TYPE_IND = 1    ---Product
    --AND LINE_TYPE_IND = 2     --- By Product
--         AND ITEM_TYPE IN ('GP COIL - NOF', 'GP COIL - CGL')
       -- and batch_no=299
GROUP BY PRODUCTION_DATE,
         BATCH_NO,
         CONCATENATED_SEGMENTS,
         LOT_NUMBER
       AND trunc(a.actual_start_date) >= '01-JAN-2014'
       AND trunc(a.actual_start_date) <= '21-JAN-2014'

 

/* Formatted on 11/17/2013 6:10:33 PM (QP5 v5.136.908.31019) */
  SELECT ORGANIZATION_CODE,
         TRANSACTION_DATE,
         TO_CHAR (TRANSACTION_DATE, 'MON-YY') AS PERIOD,
         INTER_COMPANY_DESC,
         ITEM_CODE,
         SUM (MISCELLANEOUS_RECEIVE),
         SUM (MISCELLANEOUS_ISSUE)
    FROM apps.akg_bi_misc_transactions
   WHERE organization_code IN ('CER')
--         AND ITEM_TYPE IN ('GP COIL - NOF', 'GP COIL - CGL')
GROUP BY ORGANIZATION_CODE,
         TRANSACTION_DATE,
         ITEM_CODE,
         INTER_COMPANY_DESC; 

 

--to check specific Month data 

 

/* Formatted on 11/17/2013 6:10:47 PM (QP5 v5.136.908.31019) */
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
            AS "Batch_status",
         a.actual_cmplt_date,
         SUM (DECODE (b.line_type, -1, b.actual_qty)) AS ING,
         SUM (DECODE (b.line_type, 1, b.actual_qty)) AS Prod,
         SUM (DECODE (b.line_type, 2, b.actual_qty)) AS BY_prod
    FROM apps.gme_batch_header a,
         apps.gme_material_details b,
         apps.org_organization_definitions ood,
         apps.gmd_routings_b rt
   WHERE a.organization_id IN (94, 95, 96, 97, 98)
         AND TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS') >=
               TO_DATE ('2012/08/01 00:00:00', 'RRRR/MM/DD HH24:MI:SS')
         AND TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS') <=
               TO_DATE ('2012/08/31 00:00:00', 'RRRR/MM/DD HH24:MI:SS')
         AND a.batch_id = b.batch_id
         AND a.organization_id = b.organization_id
         AND a.organization_id = ood.organization_id
         AND a.routing_id = rt.routing_id
GROUP BY a.organization_id,
         ood.organization_code,
         a.batch_no,
         a.attribute4,
         a.actual_start_date,
         a.batch_status,
         a.actual_cmplt_date,
         rt.routing_no
ORDER BY 4 DESC, 1, 3
