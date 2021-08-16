SELECT 
(CASE 
    WHEN INVENTORY_ITEM_ID=1024565 THEN (NVL(SHIPPED_QUANTITY,0)*1000)/50
    --WHEN INVENTORY_ITEM_ID IN (24402,24408,206570,992039) THEN (NVL(SHIPPED_QUANTITY, 0)) * 20
    ELSE  NVL(SHIPPED_QUANTITY, 0)
END) SHIPPED_BAG_QTY
,DC.*
FROM APPS.XXAKG_DISTRIBUTION_COST DC
          ,APPS.XXAKG_DISTRIBUTOR_BLOCK_M R
          ,APPS.ORG_ORGANIZATION_DEFINITIONS OD
WHERE 1=1
AND DC.CUSTOMER_ID = R.CUSTOMER_ID
AND      DC.ORG_ID = R.ORG_ID 
AND      DC.FROM_WAREHOUSE_ID = OD.ORGANIZATION_ID
--AND DC.CUSTOMER_ID = :P_CUSTOMER_ID
--AND APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (DC.CUSTOMER_ID) = :P_CUSTOMER_NUMBER
AND ORGANIZATION_CODE=:P_WAREHOUSE_ORG_CODE  
--AND ACTUAL_SHIPMENT_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
AND TO_CHAR (ACTUAL_SHIPMENT_DATE, 'MON-RR') = :P_PERIOD
--AND INVENTORY_ITEM_ID=1024565
--AND INVENTORY_ITEM_ID IN (206570--,1024565
--,24402,24408,992039)
--AND CUSTOMER_ID='137156'
--AND DC.MOV_ORDER_NO='MO/SCOU/1245372'
AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE DC.FROM_WAREHOUSE_ID=MSI.ORGANIZATION_ID AND DC.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
AND NVL (R.REGION_NAME, 'Not Defined') = :P_REGION
--,ORDER_NUMBER
--HAVING NVL (R.REGION_NAME, 'Not Defined') = :P_REGION
--AND DECODE(DC.FROM_WAREHOUSE_ID, 101, OD.ORGANIZATION_CODE, OD.ORGANIZATION_NAME) = :P_GHAT
ORDER BY 1, 3--, 4

--------------------------------------------------------------------------------

SELECT
*
FROM
APPS.XXAKG_DIST_COST_MOV_TEMP
WHERE 1=1
AND ORG_ID=85
AND INVENTORY_ITEM_ID NOT IN ('24408','206570')-- 4031804--206570'--'24408'--'206571'-- NOT IN ('24408','206570')
AND TRANSPORT_MODE IN
                        ('Company Truck',
                         'Company Bulk Carrier',
                         'Company Trailer')
--AND TYPE not in ('GHAT','FACTORY')



SELECT *
        FROM APPS.XXAKG_DIST_COST_MOV_V
       WHERE TRUNC (ACTUAL_SHIPMENT_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO
       --AND CUSTOMER_ID='137156'
       
       
       SELECT *
       --SUM (NVL (accounted_dr, 0) - NVL (accounted_cr, 0)) amount
              FROM APPS.XXAKG_DIST_COST_GHAT_EXP_V
             WHERE 1=1 
             --and warehouse_id = '187'
                   AND period_name = :P_PERIOD_NAME
                   --and description like '%TO/SCOU/103840%'

SELECT SUM (
                      NVL (GJL.ACCOUNTED_DR, 0) - NVL (GJL.ACCOUNTED_CR, 0))
                      BALANCE
              FROM apps.GL_JE_HEADERS GJH,
                   apps.GL_JE_LINES GJL,
                   apps.GL_CODE_COMBINATIONS CC
             WHERE     GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
                   AND GJL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
                   AND GJH.LEDGER_ID = 2025
                   AND (NVL (GJL.ACCOUNTED_DR, 0) <> 0
                        OR NVL (GJL.ACCOUNTED_CR, 0) <> 0)
                   AND GJH.JE_SOURCE <> 'Payables'
                   AND GJL.STATUS = 'P'
                   AND GJH.ACTUAL_FLAG = 'A'
                   AND GJL.PERIOD_NAME = 'AUG-19'--PERIOD
                   AND CC.SEGMENT1 = '2110'--P_COMPANY
                   AND CC.SEGMENT2 = 'DIST'--P_COST_CENTER
                   AND CC.SEGMENT3 = '4031808'--P_ACCOUNT
            UNION ALL                 -- AP Invoice which has created manually
            SELECT SUM (
                      NVL (GJL.ACCOUNTED_DR, 0) - NVL (GJL.ACCOUNTED_CR, 0))
                      BALANCE
              FROM apps.AP_INVOICES_ALL API,
                   XLA.XLA_TRANSACTION_ENTITIES XTE,
                   apps.XLA_AE_HEADERS XAH,
                   apps.XLA_AE_LINES XAL,
                   apps.GL_IMPORT_REFERENCES GIR,
                   apps.GL_JE_HEADERS GJH,
                   apps.GL_JE_LINES GJL,
                   apps.GL_CODE_COMBINATIONS CC
             WHERE     API.INVOICE_ID = XTE.SOURCE_ID_INT_1
                   AND XTE.ENTITY_ID = XAH.ENTITY_ID
                   AND XTE.ENTITY_CODE = 'AP_INVOICES'
                   AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
                   AND XAH.APPLICATION_ID = 200
                   AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
                   AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
                   AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
                   AND GIR.GL_SL_LINK_TABLE IN ('APECL', 'XLAJEL')
                   AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
                   AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0
                        OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
                   AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
                   AND GJH.ACTUAL_FLAG = 'A'
                   AND GJL.STATUS = 'P'
                   AND API.SOURCE <> 'AKG TRIP INVOICE'
                   AND GJL.PERIOD_NAME = 'AUG-19'--PERIOD
                   AND CC.SEGMENT1 = '2110'--P_COMPANY
                   AND CC.SEGMENT2 = 'DIST'--P_COST_CENTER
                   AND CC.SEGMENT3 = '4031808'--P_ACCOUNT



--------------------------------------------------------------------------------

SELECT
*
FROM
APPS.GL_PERIOD_STATUSES
WHERE 1=1
AND ADJUSTMENT_PERIOD_FLAG='N'

SELECT
*
FROM
APPS.GL_JE_HEADERS
WHERE 1=1
AND LEDGER_ID = 2025

SELECT
*
FROM
APPS.GL_JE_LINES
WHERE 1=1
AND ACCOUNTED_DR='0'

SELECT
*
FROM
APPS.GL_CODE_COMBINATIONS
WHERE 1=1
AND SEGMENT3='4031804'
AND SEGMENT1='2110'
AND SEGMENT2='DIST'



SELECT SUM (invoice_amount) invoice_amount,
                   SUM (to_qunatity) to_qunatity
              FROM (  SELECT invoice_id,
                             invoice_num,
                             MAX (invoice_amount) invoice_amount,
                             SUM (to_qunatity) to_qunatity
                        FROM APPS.XXAKG_DIST_COST_TO_COST_V
                       WHERE     org_id = 85
                             --AND to_warehouse_id = '103'--p_warehouse_id
                             --AND period_name = 'AUG-19'--P_PERIOD_NAME
                    GROUP BY invoice_id, invoice_num)

SELECT api.org_id,
          api.invoice_id,
          api.doc_sequence_value voucher_number,
          api.invoice_num,
          api.invoice_amount,
          mmt.inventory_item_id,
          mmt.organization_id from_warehouse_id,
          mmt.transfer_organization_id to_warehouse_id,
          TRUNC (mmt.transaction_date) transaction_date,
          TO_CHAR (mmt.transaction_date, 'MON-YY') period_name,
          mmt.shipment_number TO_NUMBER,
          TRUNC (mmt.transaction_date) TO_DATE,
          ABS (mmt.transaction_quantity) to_qunatity,
          mvh.hire_rate_ap,
          mvh.mov_order_no,
          mvh.transport_mode,
          mvh.final_destination
     FROM apps.mtl_transaction_types mtt,
          apps.mtl_material_transactions mmt,
          --xxakg_mov_ord_hdr mvh,  # After segregation of DO Move and TO Move
          apps.xxakg_domov_tomov_header_v mvh,
          apps.ap_invoices_all api
    WHERE     mtt.transaction_type_id = mmt.transaction_type_id
          AND mtt.transaction_type_name = 'Direct Org Transfer'
          AND mmt.attribute3 = mvh.mov_order_no
          AND mvh.mov_order_type = 'RELATED'
          AND mmt.organization_id = 101
          AND mmt.inventory_item_id NOT IN (24397, 24398)       --EXCLUDE EBAG
          AND mvh.mov_order_no = api.invoice_num
          AND mvh.org_id = api.org_id
          and to_char(trunc(mmt.transaction_date),'MON-YY') in ('AUG-19')
          --AND 


SELECT SUM (
                      NVL (GJL.ACCOUNTED_DR, 0) - NVL (GJL.ACCOUNTED_CR, 0))
                      BALANCE
              FROM APPS.AP_INVOICES_ALL API,
                   XLA.XLA_TRANSACTION_ENTITIES XTE,
                   APPS.XLA_AE_HEADERS XAH,
                   APPS.XLA_AE_LINES XAL,
                   APPS.GL_IMPORT_REFERENCES GIR,
                   APPS.GL_JE_HEADERS GJH,
                   APPS.GL_JE_LINES GJL,
                   APPS.GL_CODE_COMBINATIONS CC
             WHERE     API.INVOICE_ID = XTE.SOURCE_ID_INT_1
                   AND XTE.ENTITY_ID = XAH.ENTITY_ID
                   AND XTE.ENTITY_CODE = 'AP_INVOICES'
                   AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
                   AND XAH.APPLICATION_ID = 200
                   AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
                   AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
                   AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
                   AND GIR.GL_SL_LINK_TABLE IN ('APECL', 'XLAJEL')
                   AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
                   AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0
                        OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
                   AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
                   AND GJH.ACTUAL_FLAG = 'A'
                   AND GJL.STATUS = 'P'
                   AND API.SOURCE <> 'AKG TRIP INVOICE'
                   AND ROWNUM<=2
--                   AND GJL.PERIOD_NAME = P_PERIOD_NAME
--                   AND CC.SEGMENT1 = P_COMPANY
--                   AND CC.SEGMENT2 = P_COST_CENTER
--                   AND CC.SEGMENT3 = P_ACCOUNT;

SELECT
*
FROM
APPS.GL_IMPORT_REFERENCES GIR
WHERE 1=1
AND GIR.GL_SL_LINK_TABLE IN ('APECL')

-------------------------------------to Cost populaton

select
SUM (invoice_amount) invoice_amount,
                   SUM (to_qunatity) to_qunatity
from
(SELECT api.org_id,
          api.invoice_id,
          api.doc_sequence_value voucher_number,
          api.invoice_num,
          api.invoice_amount,
          mmt.inventory_item_id,
          mmt.organization_id from_warehouse_id,
          mmt.transfer_organization_id to_warehouse_id,
          TRUNC (mmt.transaction_date) transaction_date,
          TO_CHAR (mmt.transaction_date, 'MON-YY') period_name,
          mmt.shipment_number TO_NUMBER,
          TRUNC (mmt.transaction_date) TO_DATE,
          ABS (mmt.transaction_quantity) to_qunatity,
          mvh.hire_rate_ap,
          mvh.mov_order_no,
          mvh.transport_mode,
          mvh.final_destination
     FROM apps.mtl_transaction_types mtt,
          apps.mtl_material_transactions mmt,
          --xxakg_mov_ord_hdr mvh,  # After segregation of DO Move and TO Move
          apps.xxakg_domov_tomov_header_v mvh,
          apps.ap_invoices_all api
    WHERE     mtt.transaction_type_id = mmt.transaction_type_id
          AND mtt.transaction_type_name = 'Direct Org Transfer'
          AND mmt.attribute3 = mvh.mov_order_no
          AND mvh.mov_order_type = 'RELATED'
          AND mmt.organization_id = 101
          AND mmt.inventory_item_id NOT IN (24397, 24398)       --EXCLUDE EBAG
          AND mvh.mov_order_no = api.invoice_num
          AND mvh.org_id = api.org_id
          and to_char(trunc(mmt.transaction_date),'MON-YY') in ('AUG-19'))