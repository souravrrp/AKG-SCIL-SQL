SELECT
RCT.CUSTOMER_TRX_ID,
RCT.TRX_NUMBER,
RCT.TRX_DATE,
RCG.GL_DATE,
RCT.PURCHASE_ORDER,
OOD.ORGANIZATION_ID,
OOD.ORGANIZATION_NAME,
HCSUA.SITE_USE_ID,
HCSUA.LOCATION,
RCL.DESCRIPTION,
HCA.ACCOUNT_NUMBER,
HP.PARTY_NAME,
RTT.NAME TRANSACTION_NAME,
DECODE(RTT.TYPE,'INV','INVOICE','CM','Credit Memo','DM','Debit Memo') TRANSACTION_TYPE,
DECODE(RCL.LINE_TYPE,'LINE','LINE_TOTAL','TAX','TOTAL_TAX') LINE_TYPE,
sum((DECODE(RCT.INVOICE_CURRENCY_CODE,'INR',RCG.AMOUNT*1,RCG.AMOUNT*RCT.EXCHANGE_RATE))) TOTAL_INV_AMOUNT,  
FU.USER_ID,FU.USER_NAME
FROM
APPS.RA_CUSTOMER_TRX_ALL RCT,
APPS.RA_CUSTOMER_TRX_LINES_ALL RCL,
APPS.RA_CUST_TRX_LINE_GL_DIST_ALL RCG,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
APPS.HZ_CUST_ACCOUNTS HCA,
APPS.HZ_PARTIES HP,
APPS.RA_CUST_TRX_TYPES_ALL RTT,
APPS.FND_USER FU
,HZ_CUST_ACCT_SITES_ALL HCASA
,APPS.HZ_CUST_SITE_USES_ALL HCSUA
WHERE
RCT.CUSTOMER_TRX_ID = RCL.CUSTOMER_TRX_ID
AND RCL.CUSTOMER_TRX_LINE_ID = RCG.CUSTOMER_TRX_LINE_ID
AND RCT.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID
AND HCA.ACCOUNT_NUMBER = '186824'
AND HCA.PARTY_ID = HP.PARTY_ID
AND RCT.LAST_UPDATED_BY = FU.USER_ID
AND RCT.CUST_TRX_TYPE_ID = RTT.CUST_TRX_TYPE_ID
AND TO_NUMBER(RCT.INTERFACE_HEADER_ATTRIBUTE10) = OOD.ORGANIZATION_ID (+)
AND HCASA.CUST_ACCOUNT_ID=HCA.CUST_ACCOUNT_ID
AND HCASA.CUST_ACCT_SITE_ID=HCSUA.CUST_ACCT_SITE_ID
AND RCT.BILL_TO_SITE_USE_ID=HCSUA.SITE_USE_ID
AND ROWNUM<=3
--AND RCT.TRX_DATE BETWEEN :PFROM AND :PTO
GROUP BY
RCT.CUSTOMER_TRX_ID,RCT.TRX_NUMBER,
RCT.CUST_TRX_TYPE_ID,RCT.TRX_DATE,RCG.GL_DATE,
RCT.CUSTOMER_TRX_ID,RCT.PURCHASE_ORDER,OOD.ORGANIZATION_NAME,
RCL.DESCRIPTION,
HCA.ACCOUNT_NUMBER,OOD.ORGANIZATION_ID,
HP.PARTY_NAME,
HCSUA.SITE_USE_ID,HCSUA.LOCATION,
FU.USER_ID,FU.USER_NAME,            
RTT.NAME,RTT.TYPE,RCL.LINE_TYPE
ORDER BY RCT.TRX_DATE DESC


---------------------------------------Transactions---------------------------------------------------------

SELECT   rct.trx_number invoice_number,
                                       -- ARPS.AMOUNT_DUE_ORIGINAL BALANCE,
                                       arps.amount_due_remaining balance,
         hp.party_name bill_to_customer,
         DECODE (rctt.TYPE,
                 'CB', 'Chargeback',
                 'CM', 'Credit Memo',
                 'DM', 'Debit Memo',
                 'DEP', 'Deposit',
                 'GUAR', 'Guarantee',
                 'INV', 'Invoice',
                 'PMT', 'Receipt',
                 'Invoice'
                ) invoice_class,
         rct.invoice_currency_code currency, rct.trx_date inv_date,
         rctd.gl_date gl_date, (SELECT NAME
                                  FROM apps.ra_terms rat
                                 WHERE rat.term_id = rct.term_id) terms,
         rctt.NAME order_type
    FROM apps.ra_customer_trx_all rct,
         -- RA_CUSTOMER_TRX_LINES_ALL      RCTL,
         apps.ra_cust_trx_line_gl_dist_all rctd,
         apps.hz_parties hp,
         apps.hz_cust_accounts_all hca,
         apps.ra_cust_trx_types_all rctt,
         apps.hr_operating_units hou,
         apps.ar_payment_schedules_all arps
   WHERE rct.customer_trx_id = rctd.customer_trx_id
--AND RCT.CUSTOMER_TRX_ID       = RCTL.CUSTOMER_TRX_ID
--AND RCTL.CUSTOMER_TRX_LINE_ID = RCTD.CUSTOMER_TRX_LINE_ID
     AND rct.bill_to_customer_id = hca.cust_account_id
     AND hp.party_id = hca.party_id
     AND rct.cust_trx_type_id = rctt.cust_trx_type_id
     AND rct.org_id = rctt.org_id
     AND rct.org_id = hou.organization_id
     AND arps.customer_trx_id(+) = rct.customer_trx_id
     AND rct.org_id = NVL (:p_org_id, rct.org_id)
--     AND rct.trx_number = NVL (:trx_number, rct.trx_number)
                                                           -- KAL/2017/DE/1114
--     AND rct.trx_date BETWEEN NVL (:p_trx_date_from, rct.trx_date)  AND NVL (:p_trx_date_to, rct.trx_date)
     AND rctd.gl_date BETWEEN NVL (:p_gl_date_from, rctd.gl_date)
                          AND NVL (:p_gl_date_to, rctd.gl_date)
--     AND hp.party_name = NVL (:p_cust_name, hp.party_name)
--     AND NVL (rct.ct_reference, 'XX') =       NVL (NVL (:p_sales_order_no, rct.ct_reference), 'XX')
GROUP BY rct.trx_number,
         -- ARPS.AMOUNT_DUE_ORIGINAL,
         arps.amount_due_remaining,
         hp.party_name,
         rctt.TYPE,
         rct.invoice_currency_code,
         rct.trx_date,
         rctd.gl_date,
         rct.term_id,
         rctt.NAME;
         
         
---------------------------------------Receipt---------------------------------------------------------

SELECT 
ACR.ATTRIBUTE1 CHECK_ID                              ,
    ACR.ATTRIBUTE2 CHECK_NUMBER                                ,
    ACR.ATTRIBUTE6 RECEIPT_DATE                                ,
--    RCT.TRX_NUMBER AR_INV_NUMBER                                      ,
--    ARM.NAME PAYMENT_METHOD                                           ,
--    TO_CHAR(ACR.REVERSAL_DATE,'DD-MON-YYYY') AR_RECEIPT_REVERSAL_DATE ,
--    HOU.NAME OPERATING_UNIT_NAME                                      ,
    ACR.RECEIPT_NUMBER AR_RECEIPT_NUMBER                              ,
--    TO_CHAR(ACR.RECEIPT_DATE,'DD-MON-YYYY') AR_RECEIPT_DATE           ,
    ACR.CURRENCY_CODE ENTERED_CURRENCY_CODE                           ,
    ACR.AMOUNT*SIGN(ARA.ACCTD_AMOUNT_APPLIED_FROM) ENTERED_AMOUNT     ,
--    GSOB.CURRENCY_CODE ACCOUNTED_CURRENCY_CODE                        ,
--    ARA.ACCTD_AMOUNT_APPLIED_FROM ACCOUNTED_AMOUNT                    ,
--    GCCK.CONCATENATED_SEGMENTS CASH_GL_ACCOUNT                        ,
--    GCCK.SEGMENT1 RECEIPT_LE_ME                                       ,
--    ABA.BANK_ACCOUNT_NUM BANK_ACCOUNT_NUMBER                          ,
--    ABB.BANK_NAME BANK_NAME                                           ,
    ACR.ORG_ID                                                        ,
    ACR.STATUS                                                        ,
    ACR.CASH_RECEIPT_ID                                               ,
    ACR.REMITTANCE_BANK_ACCOUNT_ID
       ,ARA.APPLIED_CUSTOMER_TRX_ID
       ,ARA.CODE_COMBINATION_ID
--    ,
--    ARM.RECEIPT_METHOD_ID ,
--    ABA.BANK_ACCOUNT_ID   ,
--    ABB.BANK_BRANCH_ID,
        ,AL.MEANING RECEIPT_STATUS                                         
     FROM 
--     APPS.RA_CUSTOMER_TRX_ALL RCT     ,
--    APPS.AR_RECEIPT_METHODS ARM            ,
    APPS.AR_CASH_RECEIPTS_ALL ACR          ,
    APPS.AR_RECEIVABLE_APPLICATIONS_ALL ARA,
--    APPS.GL_SETS_OF_BOOKS GSOB             ,
--    APPS.GL_CODE_COMBINATIONS_KFV GCCK     ,
--    APPS.AP_BANK_ACCOUNTS_ALL ABA          ,
--    APPS.AP_BANK_BRANCHES ABB              ,
--    APPS.HR_OPERATING_UNITS HOU            ,
    APPS.AR_LOOKUPS AL                     
--    APPS.AR_RECEIPT_METHOD_ACCOUNTS_ALL ARMA
    WHERE 1=1
    AND acr.cash_receipt_id        = ara.cash_receipt_id
--  AND acr.receipt_method_id          = arm.receipt_method_id
--  AND ara.applied_customer_trx_id    = rct.customer_trx_id(+)
--  AND acr.set_of_books_id            = gsob.set_of_books_id
----  AND arma.cash_ccid                 = gcck.code_combination_id
----  AND arm.receipt_method_id          = arma.receipt_method_id
----  AND aba.bank_account_id            = arma.bank_account_id
--  AND acr.remittance_bank_account_id = aba.bank_account_id
--  AND aba.bank_branch_id             = abb.bank_branch_id
--  AND acr.org_id                     = hou.organization_id
  AND al.lookup_type                 = 'CHECK_STATUS'
  AND acr.status                     = al.lookup_code
  AND AL.LOOKUP_CODE='UNAPP'
  AND ACR.ORG_ID=84
  
  
  
SELECT
LOOKUP_TYPE
,LOOKUP_CODE
,MEANING
,DESCRIPTION
FROM
 APPS.AR_LOOKUPS AL         
 WHERE 1=1
-- AND AL.LOOKUP_TYPE= 'INV/CM'
-- AND AL.LOOKUP_TYPE= 'PAYMENT_SCHEDULE_STATUS'
 AND AL.LOOKUP_TYPE= 'CHECK_STATUS'
-- AND LOOKUP_CODE='PMT'