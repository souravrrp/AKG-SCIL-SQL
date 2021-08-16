DROP MATERIALIZED VIEW APPS.XXAKG_GL_DTL_DMV_2025;
CREATE MATERIALIZED VIEW APPS.XXAKG_GL_DTL_DMV_2025 
TABLESPACE XXAKG_TX_DATA
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             97096K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOCACHE
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD DEFERRED
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 2/9/2015 5:44:08 PM (QP5 v5.136.908.31019) */
SELECT 101 APPLICATION_ID,
       SRC.USER_JE_SOURCE_NAME JE_SOURCE,
       CAT.NAME JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       GJH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       GJH.DOC_SEQUENCE_VALUE GL_VOUCHER_NUMBER,
       GJL.JE_LINE_NUM GL_JE_LINE_NUM,
       GJH.DEFAULT_EFFECTIVE_DATE VOUCHER_DATE,
       GJL.DESCRIPTION,
       NVL (GJL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (GJL.ENTERED_CR, 0) ENTERED_CREDITS,
       NVL (GJL.ACCOUNTED_DR, 0) DEBITS,
       NVL (GJL.ACCOUNTED_CR, 0) CREDITS,
       GJL.ATTRIBUTE2 CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       'MANUAL_JV' TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       GJH.LEDGER_ID,
       GJL.CONTEXT DFF_CONTEXT,
       GJL.ATTRIBUTE1,
       GJL.ATTRIBUTE2,
       GJL.ATTRIBUTE3,
       GJL.ATTRIBUTE4,
       GJL.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM GL_JE_HEADERS GJH,
       APPS.GL_JE_LINES GJL,
       FND_DOC_SEQUENCE_CATEGORIES CAT,
       GL_JE_SOURCES_TL SRC,
       APPS.GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     GJL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
       AND GJH.JE_CATEGORY = CAT.CODE
       AND CAT.APPLICATION_ID = 101
       AND GJH.JE_SOURCE = SRC.JE_SOURCE_NAME
       --AND NVL (NVL (GJL.ACCOUNTED_DR, GJL.ACCOUNTED_CR), 0) <> 0 #Bug - Journal Line Debit and Credit both column has value
       AND (NVL (GJL.ACCOUNTED_DR, 0) <> 0 OR NVL (GJL.ACCOUNTED_CR, 0) <> 0)
       AND GJL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND GJH.JE_SOURCE NOT IN
                ('Payables',
                 'Receivables',
                 'Cash Management',
                 'Assets',
                 'Inventory',
                 'Cost Management')
       --AND GJH.JE_FROM_SLA_FLAG IS NULL
       AND GJH.ACTUAL_FLAG = 'A'
       AND GJH.LEDGER_ID = 2025
       AND TRUNC (GJL.EFFECTIVE_DATE) BETWEEN (SELECT TRUNC (
                                                         MIN (START_DATE))
                                                         Period_Start_Date
                                                 FROM gmf.gmf_period_statuses
                                                WHERE legal_entity_id = 23279
                                                      AND period_status = 'O'
                                                      AND calendar_code =
                                                            'AKG2015')
                                          AND  (SELECT TRUNC (MIN (end_date))
                                                          Period_End_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
UNION ALL
-- Receivable Transaction Invoice
SELECT 222 APPLICATION_ID,
       'AR' JE_SOURCE,
       NULL JE_SOURCE,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       XAH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAH.ACCOUNTING_DATE VOUCHER_DATE,
       ('Cust-' || CUST.CUSTOMER_NUMBER || ' Trx No-' || CT.TRX_NUMBER)
          PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       CUST.CUSTOMER_NUMBER PARTY_CODE,
       CUST.CUSTOMER_NAME PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       CT.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       CT.ATTRIBUTE1,
       CT.ATTRIBUTE2,
       CT.ATTRIBUTE3,
       CT.ATTRIBUTE4,
       CT.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM XXAKG_AR_CUSTOMER_SITE_V CUST,
       RA_CUSTOMER_TRX_ALL CT,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     CUST.CUSTOMER_ID = CT.BILL_TO_CUSTOMER_ID
       AND CT.CUSTOMER_TRX_ID(+) = XTE.SOURCE_ID_INT_1
       AND CUST.ORG_ID = XTE.SECURITY_ID_INT_1
       --          AND XTE.ENTITY_CODE IN ('TRANSACTIONS', 'ADJUSTMENTS') --#Bug Adjustment Transactions are Missing and Added a new Union
       AND XTE.ENTITY_CODE IN ('TRANSACTIONS')
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 222
       AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND CUST.SITE_USE_CODE = 'BILL_TO'
       AND CUST.PRIMARY_FLAG = 'Y'
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Only for Adjustoments
SELECT 222 APPLICATION_ID,
       'AR' JE_SOURCE,
       GJH.JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       XAH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       GJH.DOC_SEQUENCE_VALUE GL_VOUCHER_NUMBER,
       GJL.JE_LINE_NUM GL_JE_LINE_NUM,
       XAH.ACCOUNTING_DATE VOUCHER_DATE,
       ('Cust-' || CUST.CUSTOMER_NUMBER || ' Trx No-' || CT.TRX_NUMBER)
          PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       CUST.CUSTOMER_NUMBER PARTY_CODE,
       CUST.CUSTOMER_NAME PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       GJH.LEDGER_ID,
       CT.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       CT.ATTRIBUTE1,
       CT.ATTRIBUTE2,
       CT.ATTRIBUTE3,
       CT.ATTRIBUTE4,
       CT.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM XXAKG_AR_CUSTOMER_SITE_V CUST,
       RA_CUSTOMER_TRX_ALL CT,
       AR_ADJUSTMENTS_ALL ADJ,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_IMPORT_REFERENCES GIR,
       GL_JE_HEADERS GJH,
       GL_JE_LINES GJL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     CUST.CUSTOMER_ID = CT.BILL_TO_CUSTOMER_ID
       AND CT.CUSTOMER_TRX_ID = ADJ.CUSTOMER_TRX_ID
       AND ADJ.ADJUSTMENT_ID(+) = XTE.SOURCE_ID_INT_1
       AND CUST.ORG_ID = XTE.SECURITY_ID_INT_1
       AND XTE.ENTITY_CODE IN ('ADJUSTMENTS')
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 222
       AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
       AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
       AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
       AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
       AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND GJL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND GJH.ACTUAL_FLAG = 'A'
       AND GJL.STATUS = 'P'
       AND CUST.SITE_USE_CODE = 'BILL_TO'
       AND CUST.PRIMARY_FLAG = 'Y'
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Receipt
SELECT 222 APPLICATION_ID,
       'AR' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       XAH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAH.ACCOUNTING_DATE VOUCHER_DATE,
       ('Cust-' || CUST.CUSTOMER_NUMBER || ' Rcv No-' || CR.RECEIPT_NUMBER)
          PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       CUST.CUSTOMER_NUMBER PARTY_CODE,
       CUST.CUSTOMER_NAME PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       CR.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       CR.ATTRIBUTE1,
       CR.ATTRIBUTE2,
       CR.ATTRIBUTE3,
       CR.ATTRIBUTE4,
       CR.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM XXAKG_AR_CUSTOMER_SITE_V CUST,
       AR_CASH_RECEIPTS_ALL CR,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     CUST.CUSTOMER_ID(+) = CR.PAY_FROM_CUSTOMER
       AND CUST.ORG_ID(+) = CR.ORG_ID
       AND CR.CASH_RECEIPT_ID = XTE.SOURCE_ID_INT_1
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.ENTITY_CODE = 'RECEIPTS'
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 222
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND CUST.SITE_USE_CODE(+) = 'BILL_TO'
       AND CUST.PRIMARY_FLAG(+) = 'Y'
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Payables Invoice
SELECT 200 APPLICATION_ID,
       'AP' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       XAH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       XAL.DESCRIPTION PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       APS.SEGMENT1 PARTY_CODE,
       APS.VENDOR_NAME PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       API.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       API.ATTRIBUTE1,
       API.ATTRIBUTE2,
       API.ATTRIBUTE3,
       API.ATTRIBUTE4,
       API.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM AP_SUPPLIERS APS,
       AP_INVOICES_ALL API,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     NVL (APS.VENDOR_ID(+), -222) = API.VENDOR_ID
       AND API.INVOICE_ID = XTE.SOURCE_ID_INT_1
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.ENTITY_CODE = 'AP_INVOICES'
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 200
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Payables Invoice Payment
SELECT 200 APPLICATION_ID,
       'AP' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       XAH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       APC.DESCRIPTION PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       --PHP_AP_PKG.FIND_CHECK_NUMBER (APC.CHECK_NUMBER, APC.CHECK_ID)
       NULL CHEQUE_NUMBER,
       TRUNC (APC.CHECK_DATE) CHEQUE_DATE,
       XXAKG_AP_PKG.GET_VENDOR_NUMBER (APC.VENDOR_ID) PARTY_CODE,
       --          DECODE (
       --             XAH.EVENT_TYPE_CODE,
       --             'PAYMENT CREATED HARUN', XXAKG_AP_PKG.GET_BANK_NAME_FROM_ACCT_USE_ID (
       --                                       APC.CE_BANK_ACCT_USE_ID),
       --             APC.VENDOR_NAME)
       NULL PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       APC.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       APC.ATTRIBUTE1,
       APC.ATTRIBUTE2,
       APC.ATTRIBUTE3,
       APC.ATTRIBUTE4,
       APC.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM AP_CHECKS_ALL APC,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     APC.CHECK_ID = XTE.SOURCE_ID_INT_1
       AND XTE.ENTITY_CODE = 'AP_PAYMENTS'
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 200
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Bank Transfer
SELECT 260 APPLICATION_ID,
       'CM' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       CPT.TRXN_REFERENCE_NUMBER VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XEL.ACCOUNTING_DATE VOUCHER_DATE,
       --PHP_CE_PKG.get_transaction_history (CPT.TRXN_REFERENCE_NUMBER)
       NULL PARTICULARS,
       NVL (XEL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XEL.ENTERED_CR, 0) ENTERED_CREDITS,
       XEL.ACCOUNTED_DR,
       XEL.ACCOUNTED_CR,
       CPT.ATTRIBUTE1 CHEQUE_NUMBER,
       --TRUNC (TO_DATE (CPT.ATTRIBUTE2, 'YYYY/MM/DD HH24:MI:SS'))
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XEH.LEDGER_ID,
       CPT.ATTRIBUTE_CATEGORY DFF_CONTEXT,
       CPT.ATTRIBUTE1,
       CPT.ATTRIBUTE2,
       CPT.ATTRIBUTE3,
       CPT.ATTRIBUTE4,
       CPT.ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM XLA_AE_LINES XEL,
       XLA_AE_HEADERS XEH,
       CE_PAYMENT_TRANSACTIONS CPT,
       CE_CASHFLOWS CFLOW,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     XTE.APPLICATION_ID = 260
       AND XEL.APPLICATION_ID = XEH.APPLICATION_ID
       AND XTE.APPLICATION_ID = XEH.APPLICATION_ID
       AND XEL.AE_HEADER_ID = XEH.AE_HEADER_ID
       AND XTE.ENTITY_CODE = 'CE_CASHFLOWS'
       AND XTE.SOURCE_ID_INT_1 = CFLOW.CASHFLOW_ID
       AND CPT.TRXN_REFERENCE_NUMBER = CFLOW.TRXN_REFERENCE_NUMBER
       AND XTE.ENTITY_ID = XEH.ENTITY_ID
       AND (NVL (XEL.ACCOUNTED_DR, 0) <> 0 OR NVL (XEL.ACCOUNTED_CR, 0) <> 0)
       AND XEL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND XEH.LEDGER_ID = 2025
       AND TRUNC (XEL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Fixed Asset
SELECT 140 APPLICATION_ID,
       'FA' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 UNIT,
       CC.SEGMENT2 EXP_CATEGORIES,
       CC.SEGMENT3 COST_CENTER,
       CC.SEGMENT4 ACCOUNT,
       CC.SEGMENT5 PROJECT,
       FLEX.DESCRIPTION ACCTDESC,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       XAL.DESCRIPTION PARTICULARS,
       NVL (XAL.ENTERED_DR, 0) ENTERED_DEBITS,
       NVL (XAL.ENTERED_CR, 0) ENTERED_CREDITS,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL,
       NULL,
       --APS.SEGMENT1 PARTY_CODE,
       --APS.VENDOR_NAME PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX
 WHERE     XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID = 140
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Source Inventory
SELECT 555 APPLICATION_ID,
       'INV' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       xdl.TRANSACTION_ID VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAL.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       ORG.ORGANIZATION_ID,
       ORG.ORGANIZATION_CODE,
       ORG.ORGANIZATION_NAME,
       MST.INVENTORY_ITEM_ID,
       MST.SEGMENT1 ITEM_CODE_SEGMENT1,
       MST.SEGMENT2 ITEM_CODE_SEGMENT2,
       MST.SEGMENT3 ITEM_CODE_SEGMENT3,
       MST.DESCRIPTION INVENTORY_ITEM_NAME,
       MCB.SEGMENT1 ITEM_CATEGORY_SEGMENT1,
       MCB.SEGMENT2 ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM (  SELECT  /*+ parallel(geh, 20) parallel(gel, 20) parallel(xdl, 20) */
                XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE
            --round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) accounted_dr,
            --round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2) accounted_cr
            FROM gmf_xla_extract_headers geh,
                 gmf_xla_extract_lines gel,
                 XLA_DISTRIBUTION_LINKS xdl
           WHERE geh.header_id = gel.header_id AND geh.event_id = gel.event_id
                 AND geh.entity_code IN
                          ('PRODUCTION',
                           'PURCHASING',
                           'REVALUATION',
                           'ORDERMANAGEMENT',
                           'INVENTORY')
                 AND xdl.source_distribution_type = geh.entity_code
                 AND xdl.event_id = geh.event_id
                 AND xdl.source_distribution_id_num_1 = gel.line_id
                 AND xdl.APPLICATION_ID = 555
                 AND GEH.LEDGER_ID = 2025
                 AND TRUNC (GEH.TRANSACTION_DATE) BETWEEN (SELECT TRUNC(MIN(START_DATE))
                                                                     Period_Start_Date
                                                             FROM gmf.gmf_period_statuses
                                                            WHERE legal_entity_id =
                                                                     23279
                                                                  AND period_status =
                                                                        'O'
                                                                  AND calendar_code =
                                                                        'AKG2015')
                                                      AND  (SELECT TRUNC(MIN(end_date))
                                                                      Period_End_Date
                                                              FROM gmf.gmf_period_statuses
                                                             WHERE legal_entity_id =
                                                                      23279
                                                                   AND period_status =
                                                                         'O'
                                                                   AND calendar_code =
                                                                         'AKG2015')
        GROUP BY XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE) XDL,
       XLA_AE_LINES XAL,
       XLA_AE_HEADERS XAH,
       gl_code_combinations cc,
       FND_FLEX_VALUES_VL FLEX,
       MTL_SYSTEM_ITEMS_B MST,
       ORG_ORGANIZATION_DEFINITIONS ORG,
       MTL_ITEM_CATEGORIES MIC,
       MTL_CATEGORIES_B MCB
 WHERE     XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.code_combination_id = cc.code_combination_id
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND XDL.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND XDL.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND XDL.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND MIC.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND MCB.STRUCTURE_ID = 101
       AND MCB.CATEGORY_ID = MIC.CATEGORY_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Journal Category: OPM Batch Close (Since for this category system doesn't store inventory_item_id
SELECT 555 APPLICATION_ID,
       'INV' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       xdl.TRANSACTION_ID VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM (  SELECT  /*+ parallel(geh, 20) parallel(gel, 20) parallel(xdl, 20) */
                XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE
            --round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) accounted_dr,
            --round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2) accounted_cr
            FROM gmf_xla_extract_headers geh,
                 gmf_xla_extract_lines gel,
                 XLA_DISTRIBUTION_LINKS xdl
           WHERE     geh.header_id = gel.header_id
                 AND geh.event_id = gel.event_id
                 AND geh.EVENT_CLASS_CODE = 'BATCH_CLOSE'
                 AND geh.entity_code = 'PRODUCTION'
                 AND xdl.source_distribution_type = geh.entity_code
                 AND xdl.event_id = geh.event_id
                 AND xdl.source_distribution_id_num_1 = gel.line_id
                 AND xdl.APPLICATION_ID = 555
                 AND GEH.LEDGER_ID = 2025
                 AND TRUNC (GEH.TRANSACTION_DATE) BETWEEN (SELECT TRUNC(MIN(START_DATE))
                                                                     Period_Start_Date
                                                             FROM gmf.gmf_period_statuses
                                                            WHERE legal_entity_id =
                                                                     23279
                                                                  AND period_status =
                                                                        'O'
                                                                  AND calendar_code =
                                                                        'AKG2015')
                                                      AND  (SELECT TRUNC(MIN(end_date))
                                                                      Period_End_Date
                                                              FROM gmf.gmf_period_statuses
                                                             WHERE legal_entity_id =
                                                                      23279
                                                                   AND period_status =
                                                                         'O'
                                                                   AND calendar_code =
                                                                         'AKG2015')
        GROUP BY XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE) XDL,
       XLA_AE_LINES XAL,
       XLA_AE_HEADERS XAH,
       gl_code_combinations cc,
       FND_FLEX_VALUES_VL FLEX
 WHERE     XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.code_combination_id = cc.code_combination_id
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Source - Cost Management and Category -Inventory
SELECT 707 APPLICATION_ID,
       'CST' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       MMT.TRANSACTION_ID VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       XAE.EVENT_TYPE_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       ORG.ORGANIZATION_ID,
       ORG.ORGANIZATION_CODE,
       ORG.ORGANIZATION_NAME,
       MST.INVENTORY_ITEM_ID,
       MST.SEGMENT1 ITEM_CODE_SEGMENT1,
       MST.SEGMENT2 ITEM_CODE_SEGMENT2,
       MST.SEGMENT3 ITEM_CODE_SEGMENT3,
       MST.DESCRIPTION INVENTORY_ITEM_NAME,
       MCB.SEGMENT1 ITEM_CATEGORY_SEGMENT1,
       MCB.SEGMENT2 ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM MTL_MATERIAL_TRANSACTIONS MMT,
       MTL_TRANSACTION_ACCOUNTS MTA,
       XLA_TRANSACTION_ENTITIES_UPG XATE,
       XLA_EVENTS XAE,
       XLA_DISTRIBUTION_LINKS XDL,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       gl_code_combinations cc,
       FND_FLEX_VALUES_VL FLEX,
       MTL_SYSTEM_ITEMS_B MST,
       ORG_ORGANIZATION_DEFINITIONS ORG,
       MTL_CATEGORIES_B MCB,
       MTL_ITEM_CATEGORIES MIC
 WHERE     MMT.TRANSACTION_ID = MTA.TRANSACTION_ID
       AND MMT.TRANSACTION_ID = XATE.SOURCE_ID_INT_1
       AND XATE.ENTITY_ID = XAE.ENTITY_ID
       AND MTA.INV_SUB_LEDGER_ID = XDL.SOURCE_DISTRIBUTION_ID_NUM_1
       AND XDL.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       AND XDL.APPLICATION_ID = XAH.APPLICATION_ID
       AND XDL.APPLICATION_ID = 707
       AND XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_HEADER_ID = XAL.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM                         -- My Own
       AND XAL.code_combination_id = cc.code_combination_id
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND MMT.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND MMT.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MMT.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND MCB.STRUCTURE_ID = 101
       AND MCB.CATEGORY_ID = MIC.CATEGORY_ID
       AND MIC.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
-- Source - Cost Management and Category -Receiving
SELECT 707 APPLICATION_ID,
       'CST' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       RCVT.TRANSACTION_ID VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       XAE.EVENT_TYPE_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       ORG.ORGANIZATION_ID,
       ORG.ORGANIZATION_CODE,
       ORG.ORGANIZATION_NAME,
       MST.INVENTORY_ITEM_ID,
       MST.SEGMENT1 ITEM_CODE_SEGMENT1,
       MST.SEGMENT2 ITEM_CODE_SEGMENT2,
       MST.SEGMENT3 ITEM_CODE_SEGMENT3,
       MST.DESCRIPTION INVENTORY_ITEM_NAME,
       MCB.SEGMENT1 ITEM_CATEGORY_SEGMENT1,
       MCB.SEGMENT2 ITEM_CATEGORY_SEGMENT2,
       RCVH.RECEIPT_NUM GOODS_RECEIPT_NUM
  FROM PO_LINES_ALL POL,
       RCV_SHIPMENT_HEADERS RCVH,
       RCV_TRANSACTIONS RCVT,
       XLA_TRANSACTION_ENTITIES_UPG XATE,
       XLA_EVENTS XAE,
       XLA_DISTRIBUTION_LINKS XDL,
       XLA_AE_LINES XAL,
       XLA_AE_HEADERS XAH,
       gl_code_combinations cc,
       FND_FLEX_VALUES_VL FLEX,
       MTL_SYSTEM_ITEMS_B MST,
       ORG_ORGANIZATION_DEFINITIONS ORG,
       MTL_CATEGORIES_B MCB,
       MTL_ITEM_CATEGORIES MIC
 WHERE     POL.PO_LINE_ID = RCVT.PO_LINE_ID
       AND RCVH.SHIPMENT_HEADER_ID = RCVT.SHIPMENT_HEADER_ID
       AND RCVT.TRANSACTION_ID = XATE.SOURCE_ID_INT_1
       AND XATE.ENTITY_ID = XAE.ENTITY_ID
       AND XDL.EVENT_ID = XAE.EVENT_ID
       AND XDL.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
       AND XDL.APPLICATION_ID = XAH.APPLICATION_ID
       AND XDL.APPLICATION_ID = 707
       AND XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.code_combination_id = cc.code_combination_id
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND RCVT.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND POL.ITEM_ID = MST.INVENTORY_ITEM_ID
       AND RCVT.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND MCB.STRUCTURE_ID = 101
       AND MCB.CATEGORY_ID = MIC.CATEGORY_ID
       AND MIC.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015')
UNION ALL
--Inter-Company
SELECT XAH.APPLICATION_ID APPLICATION_ID,
       DECODE (XAH.APPLICATION_ID, 707, 'CST', 555, 'INV') JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       MMT.TRANSACTION_ID VOUCHER_NUMBER,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       XTE.ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       ORG.ORGANIZATION_ID,
       ORG.ORGANIZATION_CODE,
       ORG.ORGANIZATION_NAME,
       MST.INVENTORY_ITEM_ID,
       MST.SEGMENT1 ITEM_CODE_SEGMENT1,
       MST.SEGMENT2 ITEM_CODE_SEGMENT2,
       MST.SEGMENT3 ITEM_CODE_SEGMENT3,
       MST.DESCRIPTION INVENTORY_ITEM_NAME,
       MCB.SEGMENT1 ITEM_CATEGORY_SEGMENT1,
       MCB.SEGMENT2 ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM mtl_material_transactions MMT,
       XLA.XLA_TRANSACTION_ENTITIES XTE,
       XLA_AE_HEADERS XAH,
       XLA_AE_LINES XAL,
       GL_CODE_COMBINATIONS CC,
       FND_FLEX_VALUES_VL FLEX,
       MTL_SYSTEM_ITEMS_B MST,
       ORG_ORGANIZATION_DEFINITIONS ORG,
       MTL_CATEGORIES_B MCB,
       MTL_ITEM_CATEGORIES MIC
 WHERE MMT.TRANSACTION_ID = XTE.SOURCE_ID_INT_1
       AND XTE.ENTITY_ID = XAH.ENTITY_ID
       AND XTE.ENTITY_CODE IN
                ('PRODUCTION',
                 'PURCHASING',
                 'REVALUATION',
                 'ORDERMANAGEMENT',
                 'INVENTORY',
                 'MTL_ACCOUNTING_EVENTS')
       AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
       AND XAH.APPLICATION_ID IN (555, 707)
       AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
       AND XAL.ACCOUNTING_CLASS_CODE = 'INTRA'
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND MMT.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND MMT.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MMT.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND MCB.STRUCTURE_ID = 101
       AND MCB.CATEGORY_ID = MIC.CATEGORY_ID
       AND MIC.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
       AND XAH.LEDGER_ID = 2025
       AND TRUNC (XAL.ACCOUNTING_DATE) BETWEEN (SELECT TRUNC (
                                                          MIN (START_DATE))
                                                          Period_Start_Date
                                                  FROM gmf.gmf_period_statuses
                                                 WHERE legal_entity_id =
                                                          23279
                                                       AND period_status =
                                                             'O'
                                                       AND calendar_code =
                                                             'AKG2015')
                                           AND  (SELECT TRUNC (
                                                           MIN (end_date))
                                                           Period_End_Date
                                                   FROM gmf.gmf_period_statuses
                                                  WHERE legal_entity_id =
                                                           23279
                                                        AND period_status =
                                                              'O'
                                                        AND calendar_code =
                                                              'AKG2015');
