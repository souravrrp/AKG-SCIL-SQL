SELECT
*
FROM
APPS.AP_INVOICES_ALL AIA
--JOINED BY INVOICE_ID, VENDOR_ID, VENDOR_SITE_ID, PARTY_ID, PARTY_SITE_ID, 
--SEARCH BY INVOICE_NUM, SET_OF_BOOKS,
--FIND OUT PAYMENT_CURRENCY_CODE, INVOICE_AMOUNT, AMOUNT_PAID, SET_OF_BOOKS_ID, PAYMENT_METHOD_CODE, PAYMENT_STATUS_FLAG, 
--CONDITIONED BY INVOICE_TYPE_LOOKUP_CODE, DESCRIPTION, DOC_SEQUENCE_VALUE,




SELECT
*
FROM
APPS.AP_INVOICE_LINES_ALL AILA
WHERE 1=1
--JOINED BY ORG_ID, INVOICE_ID, SHIP_TO_LOCATION_ID, 
--FIND OUT DESCRIPTION, ACCOUNTING_DATE, PEIROD_NAME, AMOUNT,
--CONDITIONED BY LINE_NUMBER, LINE_TYPE_LOOKUP_CODE, 
--MISCELLANEOUS  LINE_SOURCE, MATCH_TYPE
--


SELECT
*
FROM
APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
WHERE 1=1
--FIND OUT ACCOUNTING_DATE, PERIOD_NAME, SET_OF_BOOKS_ID, AMOUNT, DESCRIPTION, TOTAL_DIST_AMOUNT, 
--ACTION_TYPE ACCRUAL_POETED_FLAG, ASSETS_TRACKING_FLAG, MATCH_STATUS_FLAG, POSTED_FLAG, 
--CONDITONED_BY DISTRIBUTION_LINE_NUMBER, LINE_TYPE_LOOKUP_CODE,  
--JOINED BY DIST_CODE_COMBINATION_ID, INVOICE_ID, ORG_ID, 


SELECT
*
FROM
APPS.AP_SUPPLIERS APS
--JOINED BY VENDOR_ID, PARTY_ID, 
--FIND OUT VENDOR_NAME, SEGMENT1, TCA_SYNC_VENDOR_NAME, 
--CONDITONED BY VENDOR_TYPE_LOOKUP_CODE, ATTRIBUTE13, 
--FLAG_STAUS HOLD_ALL_PAYMENT_FLAG, HOLD_FUTEURE_PAYMWNT_FLAG, 


SELECT
*
FROM
APPS.AP_SUPPLIER_SITES_ALL
WHERE 1=1
--JOINED BY , ORG_ID VENDOR_SITE_ID, VENDOR_ID, PARTY_SITE_ID,  LOCATION_ID SHIP_TO_LOCATION_ID, BILL_TO_LOCATION_ID, ACCTS_PAY_CODE_COMBINATION_ID, PREPAY_CODE_COMBINATION_ID
--FIND OUT VENDOR_SITE_CODE, ADDRESS_LINE1
--CONDITIONED_BY TERMS_DATE_BASIS, PAY_DATE_BASIS_LOOKUP_CODE



SELECT
*
FROM
APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
APPS.PO_DISTRIBUTIONS_ALL PDA
WHERE 1=1
AND AIDA.PO_DISTRIBUTION_ID=PDA.PO_DISTRIBUTION_ID


-----------------------------------------------------------------------------------------------------------------------------

----Payment

SELECT
*
FROM
APPS.AP_INVOICE_PAYMENTS_ALL
WHERE 1=1
--JOINED BY ORG_ID, ACCOUNTING_EVENT_ID, CHECK_ID, INVOICE_ID, INVOICE_PAYEMENT_ID, 
--FIND OUT ACCOUNTING_DATE, AMOUNT, PERIOD_NAME, BANK_ACCOUNT_NUM
--FLAG STAUS ACCRUAL_POSTED_FLAG, CASH_POSTED_FLAG, POSTED_FLAG
--CONDITIONED BY PAYMENT_NUM, 
--CONNECTED BY SET_OF_BOOKS_ID, ACCTS_PAY_CODE_COMBINATION_ID, 


SELECT
*
FROM
APPS.AP_CHECKS_ALL ACA
WHERE 1=1
--FIND OUT AMOUNT, CURRENCY, BANK_ACCOUNT_NAME, CHECK_DATE, VENDOR_NAME, CLEARED_AMOUNT, CLEARED_BASE_AMOUNT, CLEARED_DATE, ACTUAL_VALUE_DATE,
--JOIN BY CHECK_ID, DOC_SEQUENCE_ID, DOC_SEQUENCE_VALUE, ORG_ID, VENDOR_ID, VENDOR_SITE_ID, CE_BANK_ACCOUNT_USE_ID, PARTYT_ID, PAYMENT_ID, 
--CONDITIONED BY STATUS_LOOKUP_CODE, VENDOR_SITE_CODE, BANK_ACCOUNT_NUM, DOC_CATAGORY_CODE, PAYMENT_METHOD_USE_CODE, 
--


SELECT
*
FROM
APPS.AP_PAYMENT_SCHEDULES_ALL
WHERE 1=1
--JOINED BY INVOICE_ID, ORG_ID, 
--FIND OUT GROSS_AMOUNT, 
--CONDITIONED BY PAMENT_STATUS_FLAG, HOLD_FLAG, PAYMENT_METHOD_CODE,
--------------------------------------------------------------------------------------------------------------

SELECT 
        /*
        aps.segment1 vendor_number,
       aps.vendor_name vendor_name,
       assa.vendor_site_code,
       assa.pay_group_lookup_code,
       aia.invoice_num invoice_number,
       aia.invoice_date,
       aia.gl_date,
       apsa.due_date,
       aia.invoice_currency_code,
       aia.invoice_amount,
       aia.amount_paid,
       aia.pay_group_lookup_code,
       apsa.payment_priority,
       (SELECT MAX (check_date)
          FROM apps.ap_checks_all aca, apps.ap_invoice_payments_all aip
         WHERE aca.CHECK_ID = aip.CHECK_ID AND aip.invoice_id = aia.invoice_id)
          "Last Payment Made on",
          aia.cancelled_date
          */
         -----------------------------------------------------------------------------------------------------------------------
--         NVL (SUM (ps.amount_due_remaining), 0) invoice_balance,
aia.ORG_ID,
APS.SEGMENT1 vendor_NUMBER,
aps.VENDOR_NAME,
--cust_acct.ACCOUNT_NUMBER CUTOMER_NUMBER,
--party.party_name CUSTOMER_NAME,
--DECODE (RTT.TYPE, 'PMT', 'PAYMENT', 
--                             'CM', 'CREDIT MEMO', 
--                             'INV', 'INVOICES', 
--                             'DM', 'DEBIT MEMO',
--                                'Not Defined') "PAYMENT TYPE",
aia.invoice_num,
aia.INVOICE_AMOUNT,
aia.invoice_date,
aia.invoice_type_lookup_code,
AIA.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
TO_CHAR(aia.GL_DATE) GL_DATE,
aia.description,
--aia.cancelled_date,
--cc.segment2 "Cost Centre" ,
--cc.segment1 || '-' || cc.segment2 || '-' || cc.segment3 || '-' || cc.segment4 "Account",
--cc.segment3 "Natural Account",
--cust_acct.ACCOUNT_NAME,
--apsa.TRX_NUMBER,
--apsa.TRX_DATE,
--loc.ADDRESS1 ADDRESS,
--fndu.user_name user_id
aila.OVERLAY_DIST_CODE_CONCAT,
aila.DESCRIPTION Line_description,
aipa.accounting_date,
aipa.amount Payment_amount,
aipa.period_name,
aipa.bank_account_num, 
apsa.GROSS_AMOUNT, 
apsa.PAYMENT_STATUS_FLAG, 
apsa.HOLD_FLAG, 
apsa.PAYMENT_METHOD_CODE,
aca.AMOUNT CHECK_AMOUNT,  
aca.BANK_ACCOUNT_NAME, 
aca.CHECK_DATE
  FROM apps.ap_invoices_all aia,
  apps.ap_invoice_lines_all aila,
       apps.ap_suppliers aps,
       apps.ap_supplier_sites_all assa,
       apps.ap_payment_schedules_all apsa,
       apps.ap_invoice_payments_all aipa,
       apps.ap_checks_all aca
WHERE 1=1
        AND aia.invoice_id=aila.invoice_id
        and aia.vendor_id = aps.vendor_id
       AND aia.vendor_site_id = assa.vendor_site_id
       AND aps.vendor_id = assa.vendor_id
       AND aia.invoice_id = apsa.invoice_id
       AND aipa.invoice_id = aia.invoice_id
       AND aca.CHECK_ID = aipa.CHECK_ID
       and aca.STATUS_LOOKUP_CODE <> 'VOIDED'
       AND aia.org_id = 85
       AND AIA.INVOICE_NUM='MO/SCOU/966557'
--where INVOICE_TYPE_LOOKUP_CODE not IN ('MIXED','CREDIT','PREPAYMENT','STANDARD','PAYMENT REQUEST','DEBIT','EXPENSE REPORT')
--       AND ac.check_date BETWEEN TO_DATE ('01-Apr-2014', 'DD-MON-YYYY') AND TO_DATE ('30-Jun-2014 23:59:59', 'DD-MON-YYYY HH24:MI:SS')
