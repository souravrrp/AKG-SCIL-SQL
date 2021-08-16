/* Formatted on 8/29/2019 12:35:18 PM (QP5 v5.287) */
  SELECT AIA.INVOICE_ID,
         AIDA.ATTRIBUTE2 MOVE_ORDER_NO,
         AIA.DOC_SEQUENCE_VALUE "Vouchar Number",
         --TO_CHAR (AIA.INVOICE_DATE) INVOICE_DATE,
         TO_CHAR (AIDA.ACCOUNTING_DATE) ACCOUNTING_DATE,
         SUM (NVL (AIDA.AMOUNT, 0)) INVOICE_AMOUNT--,MOH.WAREHOUSE_ORG_CODE
         ,GCC.SEGMENT2 ORG_Code
         ,APPS.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID(AIDA.CREATED_BY)||' ('||APPS.XXAKG_COM_PKG.GET_USER_NAME(AIDA.CREATED_BY)||')' CREATED_BY_NAME
         ,(SELECT PPF.FULL_NAME
            FROM APPS.FND_USER FU, APPS.PER_PEOPLE_F PPF
           WHERE     AIDA.CREATED_BY = FU.USER_ID
                 AND PPF.PERSON_ID = FU.EMPLOYEE_ID
                 AND SYSDATE BETWEEN PPF.EFFECTIVE_START_DATE
                                 AND EFFECTIVE_END_DATE)
            CREATED_BY_USER,
         (SELECT FU.USER_NAME
            FROM APPS.FND_USER FU, APPS.PER_PEOPLE_F PPF
           WHERE     AIDA.CREATED_BY = FU.USER_ID
                 AND PPF.PERSON_ID = FU.EMPLOYEE_ID
                 AND SYSDATE BETWEEN PPF.EFFECTIVE_START_DATE
                                 AND EFFECTIVE_END_DATE)
            CREATED_BY_USER_ID
    FROM APPS.AP_INVOICES_ALL AIA,
         APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
         APPS.XXAKG_MOV_ORD_HDR MOH,
         APPS.AP_SUPPLIERS APS,
         APPS.GL_CODE_COMBINATIONS GCC
   WHERE     1 = 1
         AND AIA.VENDOR_ID = APS.VENDOR_ID
         AND AIA.ORG_ID = 82
         --AND MOH.WAREHOUSE_ORG_CODE='SCI'
         AND AIA.INVOICE_ID = AIDA.INVOICE_ID
         AND AIDA.ATTRIBUTE2 = MOH.MOV_ORDER_NO
         AND MOH.TRANSPORT_MODE IN
                ('Company Bulk Carrier',
                 'Company Truck',
                 'Company District Truck')
         AND AIDA.DIST_CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
         --AND DOC_SEQUENCE_VALUE IN ('218051623')
         --AND AIDA.ATTRIBUTE1='Trip Commission'
         --AND MOH.MOV_ORDER_NO='MO/SCOU/1264125'
         --AND INVOICE_NUM LIKE '18/Daudkandi-04-%'
         AND AIA.CANCELLED_DATE IS NULL
         --AND TO_CHAR(AIA.INVOICE_DATE,'RRRR')='2019'
         AND TO_CHAR (AIDA.ACCOUNTING_DATE, 'RRRR') = '2019'
         AND TO_CHAR (AIDA.ACCOUNTING_DATE, 'MON-RR') = 'JUL-19'
         --AND EXISTS(SELECT 1 FROM APPS.XXAKG_MOV_ORD_HDR MH WHERE MH.MOV_ORDER_NO=MOH.MOV_ORDER_NO AND MOH.WAREHOUSE_ORG_CODE!='SCI')
         AND EXISTS
                (SELECT 1
                   FROM APPS.AP_INVOICES_ALL AI,
                        APPS.AP_INVOICE_DISTRIBUTIONS_ALL AID
                  WHERE     AI.INVOICE_ID = AID.INVOICE_ID 
                  --AND AID.ATTRIBUTE1='Trip Commission'
                        AND AIDA.ATTRIBUTE2 = AID.ATTRIBUTE2
                        AND TO_CHAR(AIA.DOC_SEQUENCE_VALUE) != TO_CHAR(AI.DOC_SEQUENCE_VALUE))
GROUP BY AIA.INVOICE_ID,
         AIA.DOC_SEQUENCE_VALUE,
         AIDA.ACCOUNTING_DATE,
         --AIA.INVOICE_DATE,
         AIDA.ATTRIBUTE2
         --,SUM(AIDA.AMOUNT) INVOICE_AMOUNT
         --,MOH.WAREHOUSE_ORG_CODE
         ,AIDA.CREATED_BY
         ,GCC.SEGMENT2;

------------------------------------------------------------------------------------------------

  SELECT --    distinct(gc.segment3),gc.description
         DISTINCT api.invoice_id,
                  api.doc_sequence_value,
                  api.invoice_date,
                  ad.ATTRIBUTE2 move_number,
                  SUM (ad.amount)
    FROM apps.ap_invoices_all api,
         apps.ap_invoice_lines_all apl,
         apps.ap_invoice_distributions_all ad,
         apps.gl_code_combinations gc
   WHERE     apl.line_number = ad.invoice_line_number
         AND apl.invoice_id = api.invoice_id
         --               and api.org_id=86
         AND ad.invoice_id = api.invoice_id
         AND gc.code_combination_id = ad.DIST_CODE_COMBINATION_ID
         --              and api.doc_sequence_value='218245949'
         AND ad.ATTRIBUTE2 = TO_CHAR ( :move_number)
GROUP BY api.invoice_id,
         api.doc_sequence_value,
         api.invoice_date,
         ad.ATTRIBUTE2;


------------------------------------------------------------------------------------------------

SELECT AIA.DOC_SEQUENCE_VALUE "Vouchar Number",
       AIA.INVOICE_NUM,
       AIDA.ATTRIBUTE2,
       MOH.WAREHOUSE_ORG_CODE
  --,APS.*
  FROM APPS.AP_INVOICES_ALL AIA,
       APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
       APPS.XXAKG_MOV_ORD_HDR MOH,
       APPS.AP_SUPPLIERS APS
 WHERE     1 = 1
       AND AIA.VENDOR_ID = APS.VENDOR_ID
       AND AIA.ORG_ID = 82
       --AND MOH.WAREHOUSE_ORG_CODE!='SCI'
       AND AIA.INVOICE_ID = AIDA.INVOICE_ID
       AND AIDA.ATTRIBUTE2 = MOH.MOV_ORDER_NO
       AND MOH.TRANSPORT_MODE = 'Company Truck'
       --AND DOC_SEQUENCE_VALUE IN ('218051623')
       AND AIDA.ATTRIBUTE1 = 'Trip Commission'
       --AND MOH.MOV_ORDER_NO='MO/SCOU/040229'
       --AND INVOICE_NUM LIKE '18/Daudkandi-04-%'
       --AND TO_CHAR(AIA.INVOICE_DATE,'RRRR')='2017'
       AND TO_CHAR (AIA.INVOICE_DATE, 'MON-RR') = 'AUG-18'
       AND EXISTS
              (SELECT 1
                 FROM APPS.AP_INVOICES_ALL AI,
                      APPS.AP_INVOICE_DISTRIBUTIONS_ALL AID
                WHERE     AI.INVOICE_ID = AID.INVOICE_ID
                      AND AID.ATTRIBUTE1 = 'Trip Commission'
                      AND AIDA.ATTRIBUTE2 = AID.ATTRIBUTE2
                      AND AIA.DOC_SEQUENCE_VALUE != AI.DOC_SEQUENCE_VALUE);