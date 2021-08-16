--------------------------------------------------------------------------------

SELECT H.BATCH_NO,
       DECODE (H.BATCH_STATUS,
               -1, 'Cancelled',
               1, 'Pending',
               2, 'WIP',
               3, 'Completed',
               4, 'Closed')
          BATCH_STATUS,
       DECODE (D.LINE_TYPE,
               -1, 'Ingredients',
               1, 'Product',
               2, 'By Product')
          AS LINE_TYPE,
       (SELECT MSI.DESCRIPTION
          FROM APPS.MTL_SYSTEM_ITEMS_B MSI
         WHERE     MSI.INVENTORY_ITEM_ID = D.INVENTORY_ITEM_ID
               AND MSI.ORGANIZATION_ID = D.ORGANIZATION_ID)
          ITEM_CODE,
       D.ACTUAL_QTY,
       TO_CHAR (D.MATERIAL_REQUIREMENT_DATE) REQUIREMENT_DATE,
       CASE WHEN D.LINE_TYPE = '-1' THEN D.ACTUAL_QTY END
          INGREDIENTS_QUANTITY,
       CASE WHEN D.LINE_TYPE = '1' THEN D.ACTUAL_QTY END PRODUCT_QUANTITY,
       CASE WHEN D.LINE_TYPE = '2' THEN D.ACTUAL_QTY END BYPRODUCT_QUANTITY,
       D.DTL_UM UOM                                                     --,S.*
                   ,
       H.*
  --,D.*
  FROM APPS.GME_BATCH_HEADER H,
       APPS.GME_MATERIAL_DETAILS D,
       APPS.GME_BATCH_STEPS S
 WHERE     1 = 1
       AND H.BATCH_ID = D.BATCH_ID
       AND H.BATCH_ID = S.BATCH_ID
       AND H.ORGANIZATION_ID = '112'                           -- IN (201,100)
       --AND D.DTL_UM='MTN'--'MTN',--BAG'--'CFT'
       AND BATCH_NO = 42
--AND  to_char(H.PLAN_CMPLT_DATE,'MON-RR')='MAY-18'
--and to_char(D.MATERIAL_REQUIREMENT_DATE,'MON-RR')='MAY-18'
;
------------------------------------------------------------------------------------------------

SELECT *
  FROM APPS.GME_BATCH_HEADER H
 WHERE 1 = 1 AND H.ORGANIZATION_ID = 112 AND BATCH_NO = 42;


SELECT *
  FROM APPS.GME_MATERIAL_DETAILS
 WHERE 1 = 1 AND BATCH_ID = '2711448';

SELECT *
  FROM APPS.GME_BATCH_STEPS GBS
 WHERE 1 = 1 AND BATCH_ID = '2711448';


SELECT *
  FROM APPS.GME_BATCH_STEP_ACTIVITIES GBSA
 WHERE 1 = 1 AND BATCH_ID = '2711448';

SELECT *
  FROM APPS.GME_BATCH_STEP_RESOURCES GBSR
 WHERE 1 = 1 AND BATCH_ID = '2711448';


-----------------------------BATCH_STEPS--------------------------------------------------

SELECT                                                                 --GBS.*
       --,GBSA.*
       GBSR.*
  FROM APPS.GME_BATCH_STEPS GBS,
       APPS.GME_BATCH_STEP_ACTIVITIES GBSA,
       APPS.GME_BATCH_STEP_RESOURCES GBSR
 WHERE     1 = 1
       AND GBSA.BATCH_ID = GBS.BATCH_ID
       AND GBS.BATCHSTEP_ID = GBSA.BATCHSTEP_ID
       AND GBS.BATCH_ID = '2711448'
       AND GBS.BATCHSTEP_ID = GBSR.BATCHSTEP_ID
       AND GBSA.BATCH_ID = GBSR.BATCH_ID;

SELECT *
  FROM APPS.MTL_MATERIAL_TRANSACTIONS_TEMP T
 WHERE 1 = 1                                            --AND POSTING_FLAG='N'
            AND ORGANIZATION_ID IN (201, 100)
--AND to_char(T.TRANSACTION_DATE,'MON-RR')='MAY-18'
;

------------------------------------------------------------------------------------------------

SELECT * FROM APPS.GME_BATCH_HISTORY;

SELECT * FROM APPS.GME_BATCH_STEP_TRANSFERS;

SELECT * FROM APPS.GME_LAB_BATCH_LOTS;

SELECT * FROM APPS.GME_BATCH_STEP_RESOURCES;


SELECT * FROM APPS.GME_BATCH_STEPS;


SELECT * FROM APPS.GME_BATCH_STEP_ACTIVITIES;


SELECT * FROM APPS.GME_BATCH_SALES_ORDERS;


SELECT * FROM APPS.GME_BATCH_STEP_ITEMS;


SELECT * FROM APPS.GME_BATCH_HEADER;


SELECT * FROM APPS.GME_BATCH_STEP_DEPENDENCIES;


SELECT * FROM APPS.GME_BATCH_STEP_RSRC_SUMMARY;

SELECT * FROM APPS.GME_BATCH_STEP_CHARGES;



SELECT * FROM APPS.GMI_LOT_TRACE;