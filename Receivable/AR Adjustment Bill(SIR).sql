SELECT 
rta.*  --,NVL (SUM (ps.amount_due_remaining), 0) invoice_balance
FROM 
apps.ra_cust_trx_types_all rtt,
apps.ra_customer_trx_all rta,
apps.ra_cust_trx_line_gl_dist_all rgld,
apps.gl_code_combinations cc,
apps.hz_cust_accounts_all cust_acct,
apps.ar_payment_schedules_all ps,
apps.hz_cust_acct_sites_all acct_site,
apps.hz_party_sites party_site,
apps.hz_locations loc,
apps.hz_cust_site_uses_all site_uses
WHERE 
--TRUNC (ps.gl_date) <= :p_as_of_date AND 
--cust_acct.account_number = :p_account_number AND 
ps.customer_id = cust_acct.cust_account_id 
AND ps.cust_trx_type_id = rtt.cust_trx_type_id 
--AND ps.trx_date <= :p_as_of_date 
AND ps.CLASS NOT IN ('CM', 'PMT') 
AND site_uses.site_use_code = 'BILL_TO' 
AND acct_site.party_site_id = party_site.party_site_id 
AND loc.location_id = party_site.location_id 
AND NVL (site_uses.status, 'A') = 'A' 
AND cust_acct.cust_account_id = acct_site.cust_account_id 
AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id 
AND ps.customer_id = acct_site.cust_account_id 
AND ps.customer_site_use_id = site_uses.site_use_id 
AND rta.customer_trx_id = ps.customer_trx_id 
AND rta.customer_trx_id = rgld.customer_trx_id 
AND rgld.code_combination_id = cc.code_combination_id 
AND rgld.account_class = 'REV'
and rta.TRX_NUMBER='417425485'
