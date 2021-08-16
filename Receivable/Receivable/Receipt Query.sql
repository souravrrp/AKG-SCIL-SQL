---------------------------------------Unapplied Receipt Amount---------------------------
SELECT NVL (SUM (arr.amount_applied), 0) total_unapp_receipts
,cust_acct.account_number customer_no
--,(select A.CUSTOMER_NAME from APPS.XXAKG_AR_CUSTOMER_SITE_V a where A.CUSTOMER_ID=cust_acct.CUST_ACCOUNT_ID) customer_name
,ACR.ATTRIBUTE1 CHECK_ID
,ACR.ATTRIBUTE2 CHECK_NUMBER
,ACR.ATTRIBUTE6 RECEIPT_DATE
FROM apps.hz_cust_accounts_all cust_acct,
apps.ar_payment_schedules_all ps,
apps.ar_receivable_applications_all arr,
apps.hz_cust_acct_sites_all acct_site,
apps.hz_party_sites party_site,
apps.hz_locations loc,
apps.hz_cust_site_uses_all site_uses,
apps.ar_cash_receipts_all acr,
apps.ar_cash_receipt_history_all crh,
apps.gl_code_combinations cc
WHERE  ps.customer_id = cust_acct.cust_account_id 
--AND cust_acct.account_number = :p_account_number 
AND ps.customer_id = cust_acct.cust_account_id 
AND acct_site.party_site_id = party_site.party_site_id 
AND loc.location_id = party_site.location_id 
AND ps.cash_receipt_id = acr.cash_receipt_id 
AND acr.cash_receipt_id = crh.cash_receipt_id 
AND crh.account_code_combination_id = cc.code_combination_id 
AND ps.trx_date <= :p_as_of_date 
AND ps.CLASS = 'PMT' 
AND ps.cash_receipt_id = arr.cash_receipt_id 
AND arr.status = 'UNAPP' 
AND ps.status = 'OP' 
AND ACR.ORG_ID=85
AND site_uses.site_use_code = 'BILL_TO' 
AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id 
AND NVL (site_uses.status, 'A') = 'A' 
AND cust_acct.cust_account_id = acct_site.cust_account_id 
AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id 
AND ps.customer_id = acct_site.cust_account_id 
AND ps.customer_site_use_id = site_uses.site_use_id 
HAVING NVL (SUM (arr.amount_applied), 0) > 0
GROUP BY
cust_acct.account_number 
,ACR.ATTRIBUTE1
,ACR.ATTRIBUTE2
,ACR.ATTRIBUTE6
--,cust_acct.CUST_ACCOUNT_ID


---------------------------------------Uncleared  Receipt Amount--------------------------
SELECT NVL (SUM (ps.amount_due_remaining), 0) total_uncleared_receipts
,cust_acct.account_number
,ps.trx_date
FROM apps.hz_cust_accounts_all cust_acct,
apps.ar_payment_schedules_all ps,
apps.ar_receivable_applications_all arr,
apps.hz_cust_acct_sites_all acct_site,
apps.hz_party_sites party_site,
apps.hz_locations loc,
apps.hz_cust_site_uses_all site_uses,
apps.ar_cash_receipt_history_all crh,
apps.ar_cash_receipts_all acr,
apps.gl_code_combinations cc
WHERE 1=1
--AND TRUNC (ps.gl_date) <= :p_as_of_date 
AND ps.customer_id = cust_acct.cust_account_id 
--AND cust_acct.account_number = :p_account_number 
AND ps.customer_id = cust_acct.cust_account_id 
AND acct_site.party_site_id = party_site.party_site_id 
AND loc.location_id = party_site.location_id 
AND ps.cash_receipt_id = acr.cash_receipt_id 
AND acr.cash_receipt_id = crh.cash_receipt_id 
AND crh.account_code_combination_id = cc.code_combination_id 
--AND ps.trx_date <= :p_as_of_date 
AND ps.CLASS = 'PMT' 
AND ps.cash_receipt_id = arr.cash_receipt_id 
AND arr.status = 'UNAPP' 
AND ps.status = 'OP' 
AND site_uses.site_use_code = 'BILL_TO' 
AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id 
AND NVL (site_uses.status, 'A') = 'A' 
AND cust_acct.cust_account_id = acct_site.cust_account_id 
AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id 
AND ps.customer_id = acct_site.cust_account_id 
AND ps.customer_site_use_id = site_uses.site_use_id 
AND ps.cash_receipt_id = crh.cash_receipt_id 
AND crh.status NOT IN ('CLEARED') 
AND ACR.ORG_ID=84
HAVING NVL (SUM (arr.amount_applied), 0) > 0
GROUP BY
cust_acct.account_number
,ps.trx_date


---------------------------------------On Account Receipt Amount--------------------------
SELECT NVL (SUM (ps.amount_due_remaining), 0) total_onacct_receipts
,arr.status
FROM apps.hz_cust_accounts_all cust_acct,
apps.ar_payment_schedules_all ps,
apps.ar_receivable_applications_all arr,
apps.hz_cust_acct_sites_all acct_site,
apps.hz_party_sites party_site,
apps.hz_locations loc,
apps.hz_cust_site_uses_all site_uses,
apps.ar_cash_receipts_all acr,
apps.ar_cash_receipt_history_all crh,
apps.gl_code_combinations cc
WHERE 1=1
--AND TRUNC (ps.gl_date) <= :p_as_of_date 
AND ps.customer_id = cust_acct.cust_account_id 
--AND cust_acct.account_number = :p_account_number 
AND ps.customer_id = cust_acct.cust_account_id 
AND acct_site.party_site_id = party_site.party_site_id 
AND loc.location_id = party_site.location_id 
AND ps.cash_receipt_id = acr.cash_receipt_id 
AND acr.cash_receipt_id = crh.cash_receipt_id 
AND crh.account_code_combination_id = cc.code_combination_id 
--AND ps.trx_date <= :p_as_of_date 
AND ps.CLASS = 'PMT' 
AND ps.cash_receipt_id = arr.cash_receipt_id 
--AND arr.status IN ('ACC') 
AND ps.status = 'OP' 
AND site_uses.site_use_code = 'BILL_TO' 
AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id 
AND NVL (site_uses.status, 'A') = 'A' 
AND ACR.ORG_ID=84
AND cust_acct.cust_account_id = acct_site.cust_account_id 
AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id 
AND ps.customer_id = acct_site.cust_account_id 
AND ps.customer_site_use_id = site_uses.site_use_id 
HAVING NVL (SUM (arr.amount_applied), 0) > 0
GROUP BY
arr.status
