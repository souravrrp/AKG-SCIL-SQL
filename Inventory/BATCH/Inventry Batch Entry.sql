/* Formatted on 7/13/2019 9:57:56 AM (QP5 v5.287) */
  SELECT R.ROUTING_NO AS PROCESS,
         H.ACTUAL_START_DATE,
         H.ACTUAL_CMPLT_DATE ACTUAL_COMPLETE_DATE,
         H.BATCH_CLOSE_DATE BATCH_CLOSE_DATE,
         H.ATTRIBUTE3 AS SHIFT,
         H.ATTRIBUTE11 AS HEAT_NO,
         T.TRANSACTION_ID,
         TO_CHAR (T.TRANSACTION_DATE, 'DD-MON-YYYY HH24:MI:SS') AS TRANS_DATE,
         TO_CHAR (TRUNC (T.TRANSACTION_DATE), 'MON-YYYY') TXN_PERIOD,
         DECODE (H.BATCH_STATUS,
                 -1, 'Cancelled',
                 1, 'Pending',
                 2, 'WIP',
                 3, 'Completed',
                 4, 'Closed')
            AS BATCH_STATUS,
         H.BATCH_ID,
         H.BATCH_NO AS BATCH_NO,
         DECODE (D.LINE_TYPE,
                 -1, 'Ingredients',
                 1, 'Product',
                 2, 'By Product')
            AS LINE_TYPE,
         T.ORGANIZATION_ID,
         OOD.ORGANIZATION_CODE,
         T.SUBINVENTORY_CODE,
         MC.SEGMENT1 ITEM_CATEGORY,
         MC.SEGMENT1 ITEM_TYPE,
         MSI.INVENTORY_ITEM_ID,
         MSI.CONCATENATED_SEGMENTS,
         MSI.DESCRIPTION,
         T.TRANSACTION_UOM AS TRANS_UOM,
         APPS.FNC_GET_ITEM_COST (
            T.ORGANIZATION_ID,
            T.INVENTORY_ITEM_ID,
            TO_CHAR (TRUNC (T.TRANSACTION_DATE), 'MON-YY'))
            ITEM_COST,
         MTT.TRANSACTION_TYPE_NAME,
         T.PRIMARY_QUANTITY,
         CASE
            WHEN LT.LOT_NUMBER IS NOT NULL THEN LT.TRANSACTION_QUANTITY
            ELSE T.TRANSACTION_QUANTITY
         END
            AS TRANS_QTY,
         NVL (LOT.ATTRIBUTE1, 0) AS "Length",
         LOT.GRADE_CODE AS "GRADE",
         T.SECONDARY_TRANSACTION_QUANTITY AS SEC_QTY,
         T.SECONDARY_UOM_CODE,
         (CASE
             WHEN D.LINE_TYPE = '-1' AND LT.LOT_NUMBER IS NOT NULL
             THEN
                LT.TRANSACTION_QUANTITY
             ELSE
                (CASE
                    WHEN D.LINE_TYPE = '-1' AND LT.LOT_NUMBER IS NULL
                    THEN
                       D.ACTUAL_QTY
                 END)
          END)
            INGREDIENTS_QUANTITY,
         (CASE
             WHEN D.LINE_TYPE = '1' AND LT.LOT_NUMBER IS NOT NULL
             THEN
                LT.TRANSACTION_QUANTITY
             ELSE
                (CASE
                    WHEN D.LINE_TYPE = '1' AND LT.LOT_NUMBER IS NULL
                    THEN
                       D.ACTUAL_QTY
                 END)
          END)
            PRODUCT_QUANTITY,
         (CASE
             WHEN D.LINE_TYPE = '2' AND LT.LOT_NUMBER IS NOT NULL
             THEN
                LT.TRANSACTION_QUANTITY
             ELSE
                (CASE
                    WHEN D.LINE_TYPE = '2' AND LT.LOT_NUMBER IS NULL
                    THEN
                       D.ACTUAL_QTY
                 END)
          END)
            BYPRODUCT_QUANTITY
    -- lt.transaction_quantity as lot_qty,
    -- t.locator_id,
    -- lt.lot_number as lot_number,
    -- to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS') as Production_Date,
    -- d.CREATED_BY,
    -- FU.USER_NAME,
    -- t.transaction_id ,
    -- t.transaction_source_id as trans_source_id,
    -- t.trx_source_line_id as material_detail_id,
    --     ,t.*
    FROM APPS.MTL_MATERIAL_TRANSACTIONS T,
         APPS.GME_MATERIAL_DETAILS D,
         APPS.GME_BATCH_HEADER H,
         APPS.MTL_TRANSACTION_LOT_NUMBERS LT,
         APPS.MTL_LOT_NUMBERS LOT,
         APPS.GMD_ROUTINGS_B R,
         APPS.MTL_SYSTEM_ITEMS_KFV MSI,
         APPS.MTL_TRANSACTION_TYPES MTT,
         INV.MTL_ITEM_CATEGORIES MIC,
         INV.MTL_CATEGORIES_B MC,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD
   --apps.FND_USER FU
   WHERE     1 = 1
         AND D.ORGANIZATION_ID = OOD.ORGANIZATION_ID
         AND T.TRANSACTION_SOURCE_TYPE_ID = 5
         --AND t.organization_id in (99)
         --AND h.batch_id in (XXXXXX)
         AND T.TRANSACTION_SOURCE_ID = H.BATCH_ID
         AND T.ORGANIZATION_ID = H.ORGANIZATION_ID
         AND D.BATCH_ID = H.BATCH_ID
         AND D.MATERIAL_DETAIL_ID = T.TRX_SOURCE_LINE_ID
         AND LT.TRANSACTION_ID(+) = T.TRANSACTION_ID
         AND LOT.LOT_NUMBER(+) = LT.LOT_NUMBER
         AND LOT.ORGANIZATION_ID(+) = LT.ORGANIZATION_ID
         AND LOT.INVENTORY_ITEM_ID(+) = LT.INVENTORY_ITEM_ID
         AND R.ROUTING_ID = H.ROUTING_ID
         AND R.OWNER_ORGANIZATION_ID = H.ORGANIZATION_ID
         AND D.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND D.ORGANIZATION_ID = MSI.ORGANIZATION_ID
         AND T.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
         AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
         AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID
         AND MIC.CATEGORY_SET_ID = 1
         --and T.CREATED_BY=FU.USER_ID
         AND MIC.CATEGORY_ID = MC.CATEGORY_ID
         --AND H.ATTRIBUTE11='150100103'
         AND LOT.LOT_NUMBER='16M6RW09I16'
         --and  TO_CHAR(TO_DATE(h.attribute4,'MON-RR'))='APR-18'
--         AND H.BATCH_NO IN (41)
         --and msi.concatenated_segments in ('CPAP.LOTS.0001')
         --and h.batch_id in (593882)
         AND H.organization_id in (1265)
--         AND OOD.ORGANIZATION_CODE = 'G10'
         --AND h.batch_status='4'
         -- and mc.segment2 like '%RE FIRE%'
         -- and msi.concatenated_segments='EBAG.SBAG.0001'
         --and r.ROUTING_NO ='POLY BAG ( EMPTY)'--in ('SLIP PREPARATION','GLAZE PREPARATION- NORMAL','GLAZE PREPARATION- MARBLE')
         --and TRANSACTION_TYPE_NAME IN ('WIP Issue','WIP Return')     --('WIP Completion','WIP Completion Return')
         --AND to_char(trunc(t.transaction_date),'MON-YYYY')=:P_Txn_period
--         AND TRUNC (TO_DATE (H.ATTRIBUTE4, 'RRRR/MM/DD HH24:MI:SS')) BETWEEN '01-JUN-2018' AND '30-JUN-2018' ---FOR OTHER ORGANIZATION
--AND trunc (H.actual_start_date) between  '01-JUN-2018' and '30-JUN-2018'---FOR ASCP
--and to_char(t.transaction_date, 'DD-MON-YYYY HH24:MI:SS')>'30-NOV-2013 23:59:59'
--and r.ROUTING_NO='FINS'               --'REFIRE FOR KILN'
ORDER BY H.ATTRIBUTE4, H.ACTUAL_START_DATE ASC;

----------------------------------RECIPE----------------------------------------

  SELECT B.RECIPE_DESCRIPTION,
         A.RECIPE_VALIDITY_RULE_ID,
         C.INVENTORY_ITEM_ID,
         D.DESCRIPTION,
         DECODE (C.LINE_TYPE, -1, ’INGREDIENT’, ’PRODUCT’) TYPE,
         SUM (E.TRANSACTION_QUANTITY) QUANTITY
    FROM APPS.GME_BATCH_HEADER A,
         APPS.GMD_RECIPES B,
         GMD_RECIPE_VALIDITY_RULES GRR,
         APPS.GME_MATERIAL_DETAILS C,
         APPS.MTL_SYSTEM_ITEMS D,
         APPS.MTL_MATERIAL_TRANSACTIONS E
   WHERE     A.FORMULA_ID = B.FORMULA_ID
         AND A.ROUTING_ID = B.ROUTING_ID
         AND A.RECIPE_VALIDITY_RULE_ID = GRR.RECIPE_VALIDITY_RULE_ID
         AND GRR.RECIPE_ID = B.RECIPE_ID
         AND A.BATCH_ID = C.BATCH_ID
         AND A.ORGANIZATION_ID = C.ORGANIZATION_ID
         AND C.INVENTORY_ITEM_ID = D.INVENTORY_ITEM_ID
         AND C.ORGANIZATION_ID = D.ORGANIZATION_ID
         AND A.BATCH_ID = E.TRANSACTION_SOURCE_ID
         AND A.ORGANIZATION_ID = E.ORGANIZATION_ID
         AND C.INVENTORY_ITEM_ID = E.INVENTORY_ITEM_ID
         AND A.BATCH_NO IN
                (SELECT BATCH_NO
                   FROM APPS.GME_BATCH_HEADER
                  WHERE TRUNC (PLAN_START_DATE) BETWEEN :FROM_DATE AND :TO_DATE)
         AND A.ORGANIZATION_ID = :YOUR_ORG_ID
         AND TRUNC (E.TRANSACTION_DATE) BETWEEN :FROM_DATE AND :TO_DATE
GROUP BY B.RECIPE_DESCRIPTION,
         A.RECIPE_VALIDITY_RULE_ID,
         C.INVENTORY_ITEM_ID,
         D.DESCRIPTION,
         C.LINE_TYPE
ORDER BY RECIPE_DESCRIPTION;


