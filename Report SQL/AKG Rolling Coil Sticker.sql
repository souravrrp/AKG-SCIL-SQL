SELECT gbh.batch_no,
         gbh.batch_id,
         TRUNC (gbh.actual_cmplt_date),
         GBH.ATTRIBUTE6 SHIFT_INCH,
         GBH.ATTRIBUTE7 OPERATORR,
         GBH.ATTRIBUTE8 D_OPERATOR,
         TO_CHAR (TO_DATE (gbh.attribute4, 'RRRR/MM/DD HH24:MI:SS'),
                  'DD-MON-RRRR')
            QAD_DATE,
         mmt.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3)
            PICKLED_item_code,
         SUBSTR (msi.segment2, 3) * .1 PICKLED_thickness,
         mln.attribute10 PICKLED_width,
         msi.description,
         mln.attribute1 PICKLED_coil_length,
         NVL (ABS (SUM (mmt.transaction_quantity)), 0) PICKLED_INPUT_qty,
         mtlt.lot_number PICKLED_INPUT_LOT,
         mln.grade_code,
         mln.attribute4 PICKLED_no_of_pass,
         TRX_OUT.item_code ROLLED_CODE,
         TRX_OUT.resources,
         case when SUBSTR (TRX_OUT.rolled_thickness, 2) like '%0' then SUBSTR (TRX_OUT.rolled_thickness, 2,2)*.01 else SUBSTR (TRX_OUT.rolled_thickness, 2)*.01 end rolled_thickness,  
         --(SUBSTR (TRX_OUT.rolled_thickness, 2) * .001) rolled_thickness,
         TRX_OUT.rolled_width,
         TRX_OUT.description ROLLED_description,
         TRX_OUT.rolled_coil_length,
         TRX_OUT.trx_qty ROLLED_OUT_QTY,
         TRX_OUT.lot_number ROLL_NUMBER,
         TRX_OUT.grade_code ROLL_GRADE,
         TRX_OUT.no_of_pass ROLL_PASS,
         TRX_OUT.deffects ROLL_DEFFECT,
         TRX_OUT.TRIMMING_QTY,
         TRX_OUT.HR_END_QTY,
         mln.attribute5 deffects
    FROM apps.mtl_material_transactions mmt,
         apps.gme_material_details gmd,
         apps.gme_batch_header gbh,
         apps.mtl_system_items_b msi,
         apps.mtl_transaction_lot_val_v mtlt,
         apps.mtl_categories_b mcb,
         apps.mtl_item_categories mic,
         apps.mtl_transaction_types mtt,
         apps.mtl_lot_numbers mln,
         (  SELECT gbh.batch_no,
                   gbh.batch_id,
                   TRUNC (gbh.actual_cmplt_date),
                   gbsr.resources,
                   mmt.inventory_item_id,
                   (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3)
                      item_code,
                   msi.segment2 rolled_thickness,
                   mln.attribute10 rolled_width,
                   msi.description,
                   mln.attribute1 rolled_coil_length,
                   NVL (ABS (SUM (mmt.transaction_quantity)), 0) trx_qty,
                   mtlt.lot_number,
                   mln.grade_code,
                   mln.attribute4 no_of_pass,
                   mln.attribute5 deffects,
                   BY_PR.TRIMMING_QTY,
                   BY_PR.HR_END_QTY
              FROM apps.mtl_material_transactions mmt,
                   apps.gme_material_details gmd,
                   apps.gme_batch_header gbh,
                   apps.gme_batch_step_resources gbsr,
                   apps.mtl_system_items_b msi,
                   apps.mtl_transaction_lot_val_v mtlt,
                   apps.mtl_categories_b mcb,
                   apps.mtl_item_categories mic,
                   apps.mtl_transaction_types mtt,
                   apps.mtl_lot_numbers mln,
                   (SELECT batch_id,
                           NVL (TRIMMING_QTY, 0) TRIMMING_QTY,
                           NVL (HR_END_QTY, 0) HR_END_QTY
                      FROM (  SELECT gmd.batch_id,
                                     SUM (GMD.ACTUAL_QTY) QTY,
                                        MSI.SEGMENT1
                                     || '.'
                                     || MSI.SEGMENT2
                                     || '.'
                                     || MSI.SEGMENT3
                                        ITEM
                                FROM apps.GME_MATERIAL_DETAILS GMD,
                                     apps.gme_batch_header gbh,
                                     apps.MTL_SYSTEM_ITEMS_B MSI
                               WHERE     gmd.batch_id = gbh.batch_id
                                     AND gbh.organization_id = msi.organization_id
                                     AND gmd.inventory_item_id =
                                            msi.inventory_item_id
                                     AND GMD.ORGANIZATION_ID = :P_ORG
                                     AND GMD.LINE_TYPE = '2'
                                     AND (   MSI.SEGMENT1
                                          || '.'
                                          || MSI.SEGMENT2
                                          || '.'
                                          || MSI.SEGMENT3) IN
                                            ('SCRP.TRIM.0001', 'SCRP.CUTP.0001')
                            GROUP BY gmd.batch_id,
                                        MSI.SEGMENT1
                                     || '.'
                                     || MSI.SEGMENT2
                                     || '.'
                                     || MSI.SEGMENT3)
                           PIVOT
                              (SUM (QTY)
                              AS QTY
                              FOR ITEM
                              IN ('SCRP.TRIM.0001' AS TRIMMING,
                                 'SCRP.CUTP.0001' AS HR_END))) by_pr
             WHERE     mmt.transaction_source_type_id = 5
                   AND mmt.trx_source_line_id = gmd.material_detail_id
                   AND mmt.transaction_source_id = gbh.batch_id
--                   AND gmd.batch_id = gbh.batch_id
--                   AND gbh.batch_id = gbsr.batch_id
                   AND gmd.batch_id = gbsr.batch_id
                   AND gbh.organization_id = msi.organization_id
                   AND gbh.organization_id = mic.organization_id
                   AND mic.organization_id = msi.organization_id
                   AND gmd.inventory_item_id(+) = msi.inventory_item_id
                   AND gmd.inventory_item_id = mic.inventory_item_id
                   AND mic.inventory_item_id = msi.inventory_item_id
                   AND mmt.transaction_id = mtlt.transaction_id
                   AND mmt.organization_id = mtlt.organization_id
                   AND mcb.category_id = mic.category_id
                   AND gmd.batch_id = by_pr.batch_id(+)
                   AND mmt.transaction_type_id = mtt.transaction_type_id  --44
                   AND UPPER (mtt.transaction_type_name) IN
                          ('WIP COMPLETION', 'WIP COMPLETION RETURN')
                   AND mtlt.lot_number = mln.lot_number
                   AND mln.organization_id = mtlt.organization_id
                   AND gbh.organization_id = :p_org
                   AND ( :P_LOT IS NULL OR mtlt.lot_number = :P_LOT)
                   AND gbh.batch_status IN ('3', '4')
                   AND gmd.line_type = '1'
                   AND mcb.segment2 = 'ROLLING COIL'
          GROUP BY gbh.actual_cmplt_date,
                   gbh.batch_no,
                   gbh.batch_id,
                   gbsr.resources,
                   mmt.inventory_item_id,
                   (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3),
                   msi.segment2,
                   mln.attribute10,
                   --msi.segment3,
                   msi.description,
                   mln.attribute1,
                   mln.attribute4,
                   mln.attribute5,
                   mtlt.lot_number,
                   mln.grade_code,
                   BY_PR.TRIMMING_QTY,
                   BY_PR.HR_END_QTY
          ORDER BY TRUNC (gbh.actual_cmplt_date),
                   gbh.batch_id,
                   mmt.inventory_item_id) TRX_OUT
   WHERE     mmt.transaction_source_type_id = 5
         AND mmt.trx_source_line_id = gmd.material_detail_id
         AND mmt.transaction_source_id = gbh.batch_id
         AND gmd.batch_id = gbh.batch_id
         AND gbh.organization_id = msi.organization_id
         AND gbh.organization_id = mic.organization_id
         AND mic.organization_id = msi.organization_id
         AND gmd.inventory_item_id(+) = msi.inventory_item_id
         AND gmd.inventory_item_id = mic.inventory_item_id
         AND mic.inventory_item_id = msi.inventory_item_id
         AND mmt.transaction_id = mtlt.transaction_id
         AND mmt.organization_id = mtlt.organization_id
         AND mcb.category_id = mic.category_id
         AND mmt.transaction_type_id = mtt.transaction_type_id            --44
         AND UPPER (mtt.transaction_type_name) IN ('WIP ISSUE', 'WIP RETURN')
         AND mtlt.lot_number = mln.lot_number
         AND mln.organization_id = mtlt.organization_id
         AND MLN.inventory_item_id = mTLT.inventory_item_id
         --AND gbh.organization_id = :p_org
         AND gbh.batch_status IN ('3', '4')
         AND gmd.line_type = '-1'
         AND mcb.segment2 = 'PICKLED COIL'
         AND GBH.BATCH_ID = TRX_OUT.BATCH_ID
GROUP BY gbh.actual_cmplt_date,
         gbh.batch_no,
         gbh.batch_id,
         GBH.ATTRIBUTE6,
         GBH.ATTRIBUTE7,
         GBH.ATTRIBUTE8,
         gbh.attribute4,
         mmt.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3),
         msi.segment2,
         mln.attribute10,
         --msi.segment3,
         msi.description,
         mln.attribute1,
         mln.attribute4,
         TRX_OUT.resources,
         mln.attribute5,
         mtlt.lot_number,
         mln.grade_code,
         TRX_OUT.item_code,
         TRX_OUT.rolled_thickness,
         TRX_OUT.rolled_width,
         TRX_OUT.description,
         TRX_OUT.rolled_coil_length,
         TRX_OUT.trx_qty,
         TRX_OUT.lot_number,
         TRX_OUT.grade_code,
         TRX_OUT.no_of_pass,
         TRX_OUT.deffects,
         TRX_OUT.TRIMMING_QTY,
         TRX_OUT.HR_END_QTY
ORDER BY TRUNC (gbh.actual_cmplt_date), gbh.batch_id, mmt.inventory_item_id;

---------------------------------OLD QUERY--------------------------------------

SELECT gbh.batch_no,
         gbh.batch_id,
         TRUNC (gbh.actual_cmplt_date),
         GBH.ATTRIBUTE6 SHIFT_INCH,
         GBH.ATTRIBUTE7 OPERATORR,
         GBH.ATTRIBUTE8 D_OPERATOR,
         TO_CHAR (TO_DATE (gbh.attribute4, 'RRRR/MM/DD HH24:MI:SS'),
                  'DD-MON-RRRR')
            QAD_DATE,
         mmt.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3)
            PICKLED_item_code,
         SUBSTR (msi.segment2, 3) * .1 PICKLED_thickness,
         mln.attribute10 PICKLED_width,
         msi.description,
         mln.attribute1 PICKLED_coil_length,
         NVL (ABS (SUM (mmt.transaction_quantity)), 0) PICKLED_INPUT_qty,
         mtlt.lot_number PICKLED_INPUT_LOT,
         mln.grade_code,
         mln.attribute4 PICKLED_no_of_pass,
         TRX_OUT.item_code ROLLED_CODE,
         TRX_OUT.resources,
         case when SUBSTR (TRX_OUT.rolled_thickness, 2) like '%0' then SUBSTR (TRX_OUT.rolled_thickness, 2,2)*.01 else SUBSTR (TRX_OUT.rolled_thickness, 2)*.01 end rolled_thickness,  
         --(SUBSTR (TRX_OUT.rolled_thickness, 2) * .001) rolled_thickness,
         TRX_OUT.rolled_width,
         TRX_OUT.description ROLLED_description,
         TRX_OUT.rolled_coil_length,
         TRX_OUT.trx_qty ROLLED_OUT_QTY,
         TRX_OUT.lot_number ROLL_NUMBER,
         TRX_OUT.grade_code ROLL_GRADE,
         TRX_OUT.no_of_pass ROLL_PASS,
         TRX_OUT.deffects ROLL_DEFFECT,
         TRX_OUT.TRIMMING_QTY,
         TRX_OUT.HR_END_QTY,
         mln.attribute5 deffects
    FROM apps.mtl_material_transactions mmt,
         apps.gme_material_details gmd,
         apps.gme_batch_header gbh,
         apps.mtl_system_items_b msi,
         apps.mtl_transaction_lot_val_v mtlt,
         apps.mtl_categories_b mcb,
         apps.mtl_item_categories mic,
         apps.mtl_transaction_types mtt,
         apps.mtl_lot_numbers mln,
         (  SELECT gbh.batch_no,
                   gbh.batch_id,
                   TRUNC (gbh.actual_cmplt_date),
                   gbsr.resources,
                   mmt.inventory_item_id,
                   (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3)
                      item_code,
                   msi.segment2 rolled_thickness,
                   mln.attribute10 rolled_width,
                   msi.description,
                   mln.attribute1 rolled_coil_length,
                   NVL (ABS (SUM (mmt.transaction_quantity)), 0) trx_qty,
                   mtlt.lot_number,
                   mln.grade_code,
                   mln.attribute4 no_of_pass,
                   mln.attribute5 deffects,
                   BY_PR.TRIMMING_QTY,
                   BY_PR.HR_END_QTY
              FROM apps.mtl_material_transactions mmt,
                   apps.gme_material_details gmd,
                   apps.gme_batch_header gbh,
                   apps.gme_batch_step_resources gbsr,
                   apps.mtl_system_items_b msi,
                   apps.mtl_transaction_lot_val_v mtlt,
                   apps.mtl_categories_b mcb,
                   apps.mtl_item_categories mic,
                   apps.mtl_transaction_types mtt,
                   apps.mtl_lot_numbers mln,
                   (SELECT batch_id,
                           NVL (TRIMMING_QTY, 0) TRIMMING_QTY,
                           NVL (HR_END_QTY, 0) HR_END_QTY
                      FROM (  SELECT gmd.batch_id,
                                     SUM (GMD.ACTUAL_QTY) QTY,
                                        MSI.SEGMENT1
                                     || '.'
                                     || MSI.SEGMENT2
                                     || '.'
                                     || MSI.SEGMENT3
                                        ITEM
                                FROM apps.GME_MATERIAL_DETAILS GMD,
                                     apps.gme_batch_header gbh,
                                     apps.MTL_SYSTEM_ITEMS_B MSI
                               WHERE     gmd.batch_id = gbh.batch_id
                                     AND gbh.organization_id = msi.organization_id
                                     AND gmd.inventory_item_id =
                                            msi.inventory_item_id
                                     AND GMD.ORGANIZATION_ID = :P_ORG
                                     AND GMD.LINE_TYPE = '2'
                                     AND (   MSI.SEGMENT1
                                          || '.'
                                          || MSI.SEGMENT2
                                          || '.'
                                          || MSI.SEGMENT3) IN
                                            ('SCRP.TRIM.0001', 'SCRP.CUTP.0001')
                            GROUP BY gmd.batch_id,
                                        MSI.SEGMENT1
                                     || '.'
                                     || MSI.SEGMENT2
                                     || '.'
                                     || MSI.SEGMENT3)
                           PIVOT
                              (SUM (QTY)
                              AS QTY
                              FOR ITEM
                              IN ('SCRP.TRIM.0001' AS TRIMMING,
                                 'SCRP.CUTP.0001' AS HR_END))) by_pr
             WHERE     mmt.transaction_source_type_id = 5
                   AND mmt.trx_source_line_id = gmd.material_detail_id
                   AND mmt.transaction_source_id = gbh.batch_id
                   AND gmd.batch_id = gbh.batch_id
                   AND gbh.batch_id = gbsr.batch_id
                   AND gmd.batch_id = gbsr.batch_id
                   AND gbh.organization_id = msi.organization_id
                   AND gbh.organization_id = mic.organization_id
                   AND mic.organization_id = msi.organization_id
                   AND gmd.inventory_item_id(+) = msi.inventory_item_id
                   AND gmd.inventory_item_id = mic.inventory_item_id
                   AND mic.inventory_item_id = msi.inventory_item_id
                   AND mmt.transaction_id = mtlt.transaction_id
                   AND mmt.organization_id = mtlt.organization_id
                   AND mcb.category_id = mic.category_id
                   AND gmd.batch_id = by_pr.batch_id(+)
                   AND mmt.transaction_type_id = mtt.transaction_type_id  --44
                   AND UPPER (mtt.transaction_type_name) IN
                          ('WIP COMPLETION', 'WIP COMPLETION RETURN')
                   AND mtlt.lot_number = mln.lot_number
                   AND mln.organization_id = mtlt.organization_id
                   AND gbh.organization_id = :p_org
                   AND ( :P_LOT IS NULL OR mtlt.lot_number = :P_LOT)
                   AND gbh.batch_status IN ('3', '4')
                   AND gmd.line_type = '1'
                   AND mcb.segment2 = 'ROLLING COIL'
          GROUP BY gbh.actual_cmplt_date,
                   gbh.batch_no,
                   gbh.batch_id,
                   gbsr.resources,
                   mmt.inventory_item_id,
                   (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3),
                   msi.segment2,
                   mln.attribute10,
                   --msi.segment3,
                   msi.description,
                   mln.attribute1,
                   mln.attribute4,
                   mln.attribute5,
                   mtlt.lot_number,
                   mln.grade_code,
                   BY_PR.TRIMMING_QTY,
                   BY_PR.HR_END_QTY
          ORDER BY TRUNC (gbh.actual_cmplt_date),
                   gbh.batch_id,
                   mmt.inventory_item_id) TRX_OUT
   WHERE     mmt.transaction_source_type_id = 5
         AND mmt.trx_source_line_id = gmd.material_detail_id
         AND mmt.transaction_source_id = gbh.batch_id
         AND gmd.batch_id = gbh.batch_id
         AND gbh.organization_id = msi.organization_id
         AND gbh.organization_id = mic.organization_id
         AND mic.organization_id = msi.organization_id
         AND gmd.inventory_item_id(+) = msi.inventory_item_id
         AND gmd.inventory_item_id = mic.inventory_item_id
         AND mic.inventory_item_id = msi.inventory_item_id
         AND mmt.transaction_id = mtlt.transaction_id
         AND mmt.organization_id = mtlt.organization_id
         AND mcb.category_id = mic.category_id
         AND mmt.transaction_type_id = mtt.transaction_type_id            --44
         AND UPPER (mtt.transaction_type_name) IN ('WIP ISSUE', 'WIP RETURN')
         AND mtlt.lot_number = mln.lot_number
         AND mln.organization_id = mtlt.organization_id
         AND MLN.inventory_item_id = mTLT.inventory_item_id
         --AND gbh.organization_id = :p_org
         AND gbh.batch_status IN ('3', '4')
         AND gmd.line_type = '-1'
         AND mcb.segment2 = 'PICKLED COIL'
         AND GBH.BATCH_ID = TRX_OUT.BATCH_ID
GROUP BY gbh.actual_cmplt_date,
         gbh.batch_no,
         gbh.batch_id,
         GBH.ATTRIBUTE6,
         GBH.ATTRIBUTE7,
         GBH.ATTRIBUTE8,
         gbh.attribute4,
         mmt.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3),
         msi.segment2,
         mln.attribute10,
         --msi.segment3,
         msi.description,
         mln.attribute1,
         mln.attribute4,
         TRX_OUT.resources,
         mln.attribute5,
         mtlt.lot_number,
         mln.grade_code,
         TRX_OUT.item_code,
         TRX_OUT.rolled_thickness,
         TRX_OUT.rolled_width,
         TRX_OUT.description,
         TRX_OUT.rolled_coil_length,
         TRX_OUT.trx_qty,
         TRX_OUT.lot_number,
         TRX_OUT.grade_code,
         TRX_OUT.no_of_pass,
         TRX_OUT.deffects,
         TRX_OUT.TRIMMING_QTY,
         TRX_OUT.HR_END_QTY
ORDER BY TRUNC (gbh.actual_cmplt_date), gbh.batch_id, mmt.inventory_item_id

-------------------------------------Value_set----------------------------------
SELECT
MLN.LOT_NUMBER,
MAX(LENGTH(MLN.LOT_NUMBER)) LOT_LEN
FROM
APPS.mtl_lot_numbers mln,APPS.mtl_item_categories mic,APPS.mtl_categories_b mcb
WHERE 1=1
AND mln.organization_id IN (94,96,1265) 
and mic.organization_id = mln.organization_id  
AND mic.inventory_item_id = mln.inventory_item_id 
and mic.category_id=mcb.category_id 
AND mcb.segment2 = 'ROLLING COIL' 
--order by mln.creation_date desc
GROUP BY MLN.LOT_NUMBER
ORDER BY LENGTH(MLN.LOT_NUMBER) DESC

--------------------------------------------------------------------------------

