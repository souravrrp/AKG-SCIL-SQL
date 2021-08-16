SELECT 
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
gcc.segment2 "Cost Centre" ,
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 "Account",
gcc.segment3 "Natural Account",
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
,assa.ADDRESS_LINE1 ADDRESS
,fndu.user_name user_id
--,AIDA.*
  FROM apps.ap_invoices_all aia,
  apps.ap_invoice_lines_all aila,
       apps.ap_suppliers aps,
       apps.ap_supplier_sites_all assa,
       apps.ap_payment_schedules_all apsa,
       apps.ap_invoice_payments_all aipa,
       apps.ap_checks_all aca
       ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
       ,apps.gl_code_combinations gcc
       ,apps.fnd_user fndu
       -------------------------------------------------------
--apps.hz_cust_accounts cust_acct,
--apps.hz_cust_acct_sites_all acct_site,
--apps.hz_party_sites party_site,
--APPS.HZ_PARTIES party,
--apps.hz_locations loc,
--apps.hz_cust_site_uses_all site_uses,
WHERE 1=1
        AND aia.invoice_id=aila.invoice_id
        and aia.vendor_id = aps.vendor_id
       AND aia.vendor_site_id = assa.vendor_site_id
       AND aps.vendor_id = assa.vendor_id
       AND aia.invoice_id = apsa.invoice_id
       AND aipa.invoice_id = aia.invoice_id
       AND aca.CHECK_ID = aipa.CHECK_ID
       and AIA.INVOICE_ID=AIDA.INVOICE_ID
       and aipa.ACCTS_PAY_CODE_COMBINATION_ID=gcc.code_combination_id
       and fndu.user_id=aia.LAST_UPDATED_BY
       and aca.STATUS_LOOKUP_CODE <> 'VOIDED'
       AND aia.org_id = 85
       AND AIA.INVOICE_NUM='MO/SCOU/966557'
--where INVOICE_TYPE_LOOKUP_CODE not IN ('MIXED','CREDIT','PREPAYMENT','STANDARD','PAYMENT REQUEST','DEBIT','EXPENSE REPORT')
--       AND ac.check_date BETWEEN TO_DATE ('01-Apr-2014', 'DD-MON-YYYY') AND TO_DATE ('30-Jun-2014 23:59:59', 'DD-MON-YYYY HH24:MI:SS')

