SELECT TO_CHAR (trx_date, 'DD-MON-RRRR') TRN_DATE,
         SUM (NVL (special_mill1_qty, 0)) special_mill1_qty,
         SUM (NVL (special_mill2_qty, 0)) special_mill2_qty,
         SUM (NVL (special_mill3_qty, 0)) special_mill3_qty,
         SUM (NVL (special_mill4_qty, 0)) special_mill4_qty,
         (  SUM (NVL (special_mill1_qty, 0))
          + SUM (NVL (special_mill2_qty, 0))
          + SUM (NVL (special_mill3_qty, 0))
          + SUM (NVL (special_mill4_qty, 0)))
            special_total,
         SUM (NVL (popular_mill1_qty, 0)) popular_mill1_qty,
         SUM (NVL (popular_mill2_qty, 0)) popular_mill2_qty,
         SUM (NVL (popular_mill3_qty, 0)) popular_mill3_qty,
         SUM (NVL (popular_mill4_qty, 0)) popular_mill4_qty,
         (  SUM (NVL (popular_mill1_qty, 0))
          + SUM (NVL (popular_mill2_qty, 0))
          + SUM (NVL (popular_mill3_qty, 0))
          + SUM (NVL (popular_mill4_qty, 0)))
            popular_total,
      SUM (NVL (OPC_mill1_qty, 0)) OPC_mill1_qty,
         SUM (NVL (OPC_mill2_qty, 0)) OPC_mill2_qty,
         SUM (NVL (OPC_mill3_qty, 0)) OPC_mill3_qty,
         SUM (NVL (OPC_mill4_qty, 0)) OPC_mill4_qty,
         (  SUM (NVL (OPC_mill1_qty, 0))
          + SUM (NVL (OPC_mill2_qty, 0))
          + SUM (NVL (OPC_mill3_qty, 0))
          + SUM (NVL (OPC_mill4_qty, 0)))
           OPC_total,
      SUM (NVL (CEM3_mill1_qty, 0)) CEM3_mill1_qty,
         SUM (NVL (CEM3_mill2_qty, 0)) CEM3_mill2_qty,
         SUM (NVL (CEM3_mill3_qty, 0)) CEM3_mill3_qty,
         SUM (NVL (CEM3_mill4_qty, 0)) CEM3_mill4_qty,
         (  SUM (NVL (CEM3_mill1_qty, 0))
          + SUM (NVL (CEM3_mill2_qty, 0))
          + SUM (NVL (CEM3_mill3_qty, 0))
          + SUM (NVL (CEM3_mill4_qty, 0)))
           CEM3_total,                                     
         (  SUM (NVL (special_mill1_qty, 0))
          + SUM (NVL (special_mill2_qty, 0))
          + SUM (NVL (special_mill3_qty, 0))
          + SUM (NVL (special_mill4_qty, 0)))
         + (  SUM (NVL (popular_mill1_qty, 0))
            + SUM (NVL (popular_mill2_qty, 0))
            + SUM (NVL (popular_mill3_qty, 0))
            + SUM (NVL (popular_mill4_qty, 0)))
             + (  SUM (NVL (OPC_mill1_qty, 0))
            + SUM (NVL (OPC_mill2_qty, 0))
            + SUM (NVL (OPC_mill3_qty, 0))
            + SUM (NVL (OPC_mill4_qty, 0)))
            sp_po_total
    FROM (SELECT TRX_DATE,
                 DESCRIPTION,
                 NVL (MILL1_QTY, 0) MILL1_QTY,
                 NVL (MILL2_QTY, 0) MILL2_QTY,
                 NVL (MILL3_QTY, 0) MILL3_QTY,
                 NVL (MILL4_QTY, 0) MILL4_QTY,
                   NVL (MILL1_QTY, 0)
                 + NVL (MILL2_QTY, 0)
                 + NVL (MILL3_QTY, 0)
                 + NVL (MILL4_QTY, 0)
                    TOTAL
            FROM (SELECT XX.TRX_DATE,
                         DECODE (MSI.DESCRIPTION,
                                 'BULK Cement (Popular)', 'Popular',
                                 'BULK Cement (Special)', 'Special',
                                 'Ordinary Portland Cement (Bulk)','OPC',
                                 'BULK Cement (CEM-3)', 'CEM3')
                            DESCRIPTION,
                         NVL (XX.ingredients, 0) ingredients_QTY,
                         XX.RESOURCES
                    FROM apps.MTL_SYSTEM_ITEMS_B MSI,
                         (  SELECT TRUNC(TO_DATE (GBH.ATTRIBUTE4,
                                                  'RRRR/MM/DD HH24:MI:SS'))
                                      TRX_DATE,
                                   msi.DESCRIPTION,
                                   MSI.ORGANIZATION_ID,
                                   SUM ( (MMT.TRANSACTION_QUANTITY)) ingredients,
                                   gbsr.resources
                              FROM apps.MTL_SYSTEM_ITEMS_B MSI,
                                   apps.MTL_MATERIAL_TRANSACTIONS MMT,
                                   apps.mtl_transaction_types mtt,
                                   apps.GME_MATERIAL_DETAILS GMD,
                                   apps.GME_BATCH_HEADER GBH,
                                   apps.GME_BATCH_STEP_RESOURCES GBSR
                             WHERE UPPER (MSI.DESCRIPTION) IN
                                         ('BULK CEMENT (POPULAR)',
                                          'BULK CEMENT (SPECIAL)',
                                          'ORDINARY PORTLAND CEMENT (BULK)',
                                          'BULK CEMENT (CEM-3)')
                                   AND MSI.ORGANIZATION_ID = :P_ORG
                                   AND MSI.ORGANIZATION_ID = MMT.ORGANIZATION_ID
                                   AND MSI.INVENTORY_ITEM_ID =
                                         MMT.INVENTORY_ITEM_ID
                                   AND mmt.transaction_type_id =
                                         mtt.transaction_type_id
                                   AND GBH.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                                   AND MSI.ORGANIZATION_ID = GMD.ORGANIZATION_ID
                                   AND GBH.ORGANIZATION_ID = GBSR.ORGANIZATION_ID
                                   AND MSI.ORGANIZATION_ID = GBSR.ORGANIZATION_ID
                                   AND mmt.transaction_source_id = gbh.batch_id
                                   AND GMD.INVENTORY_ITEM_ID =
                                         MSI.INVENTORY_ITEM_ID
                                   AND GBH.BATCH_ID = GBSR.BATCH_ID
                                   AND GMD.BATCH_ID = GBSR.BATCH_ID
                                   AND GBH.BATCH_ID = GMD.BATCH_ID
                                   AND GMD.LINE_TYPE = '1'
                                   AND GBH.BATCH_STATUS IN ('2', '3', '4') --NEED TO ADD WIP TO CALCULATE ACCURATELY
                                   AND UPPER (mtt.transaction_type_name) IN
                                            ('WIP COMPLETION',
                                             'WIP COMPLETION RETURN')
                                   AND UPPER (gbsr.resources) LIKE 'BALLMILL%'
                                   --AND TRUNC(TO_DATE(GBH.ATTRIBUTE4,'RRRR/MM/DD HH24:MI:SS'))BETWEEN (:PL_DATE) AND (:PH_DATE)
                                   --AND TRUNC(TO_DATE (GBH.ATTRIBUTE4,'RRRR/MM/DD HH24:MI:SS')) BETWEEN TRUNC(:PL_DATE) AND  TRUNC(:PH_DATE)
                          and trunc(mmt.TRANSACTION_DATE)=:p_date
                          GROUP BY TRUNC(TO_DATE (GBH.ATTRIBUTE4,
                                                  'RRRR/MM/DD HH24:MI:SS')),
                                   MSI.ORGANIZATION_ID,
                                   msi.DESCRIPTION,
                                   gbsr.resources) xx
                   WHERE UPPER (MSI.DESCRIPTION) IN
                               ('BULK CEMENT (POPULAR)',
                                'BULK CEMENT (SPECIAL)',
                                'ORDINARY PORTLAND CEMENT (BULK)',
                                'BULK CEMENT (CEM-3)')
                         AND msi.DESCRIPTION = XX.DESCRIPTION(+)
                         AND MSI.ORGANIZATION_ID = XX.ORGANIZATION_ID(+)
                         AND MSI.ORGANIZATION_ID = :P_ORG) PIVOT (SUM(ingredients_qty) AS qty
                                                           FOR resources
                                                           IN ('BALLMILL-1' AS MILL1,
                                                           'BALLMILL-2' AS MILL2,
                                                           'BALLMILL-3' AS MILL3,
                                                           'BALLMILL-4' AS MILL4))) PIVOT (SUM(MILL1_QTY) AS MILL1_QTY,
                                                                                          SUM(MILL2_QTY) AS MILL2_QTY,
                                                                                          SUM(MILL3_QTY) AS MILL3_QTY,
                                                                                          SUM(MILL4_QTY) AS MILL4_QTY
                                                                                    FOR DESCRIPTION
                                                                                    IN ('Special' AS Special,
                                                                                    'Popular' AS Popular,
                                                                                    'OPC' as OPC,
                                                                                    'CEM3' as CEM3))
GROUP BY trx_date
ORDER BY trx_date
