/* Formatted on 8/29/2019 9:34:16 AM (QP5 v5.287) */
WITH XX_PROVISION_SUMMARY_TAB
     AS (SELECT AID.ATTRIBUTE_CATEGORY DFF_CONTEXT,
                AID.ATTRIBUTE1 PROGRAM_NAME,
                AID.ATTRIBUTE2 HEAD_OF_EXPENDITURE,
                GCC.SEGMENT2 Cost_Centre,
                   GCC.SEGMENT1
                || '-'
                || GCC.SEGMENT2
                || '-'
                || GCC.SEGMENT3
                || '-'
                || GCC.SEGMENT4
                   Account,
                GCC.SEGMENT3 Natural_Account,
                FFVV.DESCRIPTION Natural_Account_Name,
                AID.AMOUNT DISTRIBUTION_AMMOUNT
           FROM APPS.AP_INVOICES_ALL AI,
                APPS.HR_OPERATING_UNITS HOU,
                APPS.AP_SUPPLIERS APS,
                APPS.AP_SUPPLIER_SITES_ALL APSS,
                APPS.AP_INVOICE_LINES_ALL AIL,
                APPS.AP_INVOICE_DISTRIBUTIONS_ALL AID,
                APPS.GL_CODE_COMBINATIONS GCC,
                APPS.FND_FLEX_VALUES_VL FFVV
          WHERE     1 = 1
                AND AI.DOC_SEQUENCE_VALUE IN (218261306)
                --    and ai.org_id in (85)
                AND AI.ORG_ID = HOU.ORGANIZATION_ID
                AND AI.VENDOR_ID = APS.VENDOR_ID
                AND AI.VENDOR_SITE_ID = APSS.VENDOR_SITE_ID
                AND AI.INVOICE_ID = AIL.INVOICE_ID
                AND AI.ORG_ID = AIL.ORG_ID
                AND AI.INVOICE_ID = AID.INVOICE_ID
                AND AI.ORG_ID = AID.ORG_ID
                AND AIL.LINE_NUMBER = AID.INVOICE_LINE_NUMBER
                AND AID.DIST_CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
                AND (AIL.DISCARDED_FLAG = 'N' OR AIL.DISCARDED_FLAG IS NULL)
                AND (AIL.CANCELLED_FLAG = 'N' OR AIL.CANCELLED_FLAG IS NULL)
                AND (AID.REVERSAL_FLAG = 'N' OR AID.REVERSAL_FLAG IS NULL)
                AND AI.CANCELLED_DATE IS NULL
                AND FFVV.FLEX_VALUE = GCC.SEGMENT3
                AND GCC.SEGMENT3 = '1050316'
                AND GCC.SEGMENT2 = 'NUL'
         UNION ALL
         SELECT RCTL.ATTRIBUTE_CATEGORY DFF_CONTEXT,
                RCTL.ATTRIBUTE1 PROGRAM_NAME,
                RCTL.ATTRIBUTE2 HEAD_OF_EXPENDITURE,
                GCC.SEGMENT2 Cost_Centre,
                   GCC.SEGMENT1
                || '-'
                || GCC.SEGMENT2
                || '-'
                || GCC.SEGMENT3
                || '-'
                || GCC.SEGMENT4
                   Account,
                GCC.SEGMENT3 Natural_Account,
                FFVV.DESCRIPTION Natural_Account_Name,
                ABS (RGLD.AMOUNT) DISTRIBUTION_AMMOUNT
           FROM APPS.RA_CUSTOMER_TRX_ALL RCT,
                APPS.RA_CUSTOMER_TRX_LINES_ALL RCTL,
                APPS.RA_CUST_TRX_TYPES_ALL RCTT,
                APPS.RA_CUST_TRX_LINE_GL_DIST_ALL RGLD,
                APPS.GL_CODE_COMBINATIONS GCC,
                APPS.FND_FLEX_VALUES_VL FFVV,
                APPS.HR_OPERATING_UNITS HOU
          WHERE     1 = 1
                AND RCT.ORG_ID = 85
                AND RCT.ORG_ID = HOU.ORGANIZATION_ID
                AND RCT.TRX_NUMBER = '418332947'
                AND RCT.CUSTOMER_TRX_ID = RCTL.CUSTOMER_TRX_ID
                AND RCT.CUST_TRX_TYPE_ID = RCTT.CUST_TRX_TYPE_ID
                AND RCT.CUSTOMER_TRX_ID = RGLD.CUSTOMER_TRX_ID
                AND RGLD.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
                AND FFVV.FLEX_VALUE = GCC.SEGMENT3
                AND GCC.SEGMENT3 = '1050316'
                AND GCC.SEGMENT2 = 'NUL'
                --AND TO_CHAR (RCT.CREATION_DATE, 'DD-MON-RR') = '27-AUG-19'
                AND NVL (RCT.COMPLETE_FLAG, 'Y') = 'Y')
  SELECT DFF_CONTEXT,
         PROGRAM_NAME,
         HEAD_OF_EXPENDITURE,
         COST_CENTRE,
         ACCOUNT,
         NATURAL_ACCOUNT,
         NATURAL_ACCOUNT_NAME,
         SUM (DISTRIBUTION_AMMOUNT) AMOUNT
    FROM XX_PROVISION_SUMMARY_TAB
GROUP BY DFF_CONTEXT,
         PROGRAM_NAME,
         HEAD_OF_EXPENDITURE,
         COST_CENTRE,
         ACCOUNT,
         NATURAL_ACCOUNT,
         NATURAL_ACCOUNT_NAME
ORDER BY 1