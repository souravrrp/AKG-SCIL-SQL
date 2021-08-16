-- Query for Total On Account Receipt Amount
SELECT NVL(SUM(ps.amount_due_remaining), 0) total_onacct_receipts
  FROM APPS.hz_cust_accounts_all           cust_acct,
       APPS.ar_payment_schedules_all       ps,
       APPS.ar_receivable_applications_all arr,
       APPS.hz_cust_acct_sites_all         acct_site,
       APPS.hz_party_sites                 party_site,
       APPS.hz_locations                   loc,
       APPS.hz_cust_site_uses_all          site_uses,
       APPS.ar_cash_receipts_all           acr,
       APPS.ar_cash_receipt_history_all    crh,
       APPS.gl_code_combinations           cc
 WHERE 1=1
-- AND TRUNC(ps.gl_date) <= :p_as_of_date
   AND ps.customer_id = cust_acct.cust_account_id
--   AND cust_acct.account_number = :p_account_number
   AND ps.customer_id = cust_acct.cust_account_id
   AND acct_site.party_site_id = party_site.party_site_id
   AND loc.location_id = party_site.location_id
   AND ps.cash_receipt_id = acr.cash_receipt_id
   AND acr.cash_receipt_id = crh.cash_receipt_id
   AND crh.account_code_combination_id = cc.code_combination_id
   AND TO_CHAR (ps.trx_date, 'MON-RR') = 'DEC-17'
--   AND ps.trx_date <= :p_as_of_date
   AND ps.CLASS = 'PMT'
   AND ps.cash_receipt_id = arr.cash_receipt_id
   AND arr.status IN ('ACC')
   AND ps.status = 'OP'
   AND site_uses.site_use_code = 'BILL_TO'
   AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id
   AND NVL(site_uses.status, 'A') = 'A'
   AND cust_acct.cust_account_id = acct_site.cust_account_id
   AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id
   AND ps.customer_id = acct_site.cust_account_id
   AND ps.customer_site_use_id = site_uses.site_use_id HAVING
 NVL(SUM(arr.amount_applied), 0) > 0;

-- Query for Total Unapplied Receipt Amount 

SELECT NVL(SUM(arr.amount_applied), 0) total_unapp_receipts
  FROM APPS.hz_cust_accounts_all           cust_acct,
       APPS.ar_payment_schedules_all       ps,
       APPS.ar_receivable_applications_all arr,
       APPS.hz_cust_acct_sites_all         acct_site,
       APPS.hz_party_sites                 party_site,
       APPS.hz_locations                   loc,
       APPS.hz_cust_site_uses_all          site_uses,
       APPS.ar_cash_receipts_all           acr,
       APPS.ar_cash_receipt_history_all    crh,
       APPS.gl_code_combinations           cc
 WHERE TRUNC(ps.gl_date) <= :p_as_of_date
   AND ps.customer_id = cust_acct.cust_account_id
   AND cust_acct.account_number = :p_account_number
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
   and acr.ORG_ID=83
   AND site_uses.site_use_code = 'BILL_TO'
   AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id
   AND NVL(site_uses.status, 'A') = 'A'
   AND cust_acct.cust_account_id = acct_site.cust_account_id
   AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id
   AND ps.customer_id = acct_site.cust_account_id
   AND ps.customer_site_use_id = site_uses.site_use_id HAVING
 NVL(SUM(arr.amount_applied), 0) > 0;

-- Query for Total Uncleared Receipt Amount 

SELECT NVL(SUM(ps.amount_due_remaining), 0) total_uncleared_receipts
  FROM APPS.hz_cust_accounts_all           cust_acct,
       APPS.ar_payment_schedules_all       ps,
       APPS.ar_receivable_applications_all arr,
       APPS.hz_cust_acct_sites_all         acct_site,
       APPS.hz_party_sites                 party_site,
       APPS.hz_locations                   loc,
       APPS.hz_cust_site_uses_all          site_uses,
       APPS.ar_cash_receipt_history_all    crh,
       APPS.ar_cash_receipts_all           acr,
       APPS.gl_code_combinations           cc
 WHERE TRUNC(ps.gl_date) <= :p_as_of_date
   AND ps.customer_id = cust_acct.cust_account_id
   AND cust_acct.account_number = :p_account_number
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
   AND site_uses.site_use_code = 'BILL_TO'
   AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id
   AND NVL(site_uses.status, 'A') = 'A'
   AND cust_acct.cust_account_id = acct_site.cust_account_id
   AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id
   AND ps.customer_id = acct_site.cust_account_id
   AND ps.customer_site_use_id = site_uses.site_use_id
   AND ps.cash_receipt_id = crh.cash_receipt_id
   AND crh.status NOT IN ('CLEARED') HAVING
 NVL(SUM(arr.amount_applied), 0) > 0;
 
 ------------------------------------------------------------------------------------------------------------------------------
 
 
 ------------------Query to get Open Invoices/CM for Deferred date/Immediate Days

SELECT 'OPEN A/R' conv_type,
       NVL((SELECT 'FUTURE DEFERRED'
  from  apps.ra_customer_trx_lines_All xrctl, apps.ra_cust_trx_line_gl_dist_all xrctlgd
  where  xrctl.customer_trx_id = rct.customer_trx_id
  and     xrctlgd.customer_trx_line_id = xrctl.customer_trx_line_id
  and xrctlgd.account_class = 'REV'
  and  xrctlgd.posting_control_id = -3
  and xrctlgd.original_gl_date >= trunc(to_date('10012014','MMDDYYYY'))
  and  rownum = 1
    ),'REGULAR') deferred_or_regular
     , trunc(to_date('10012014','MMDDYYYY')) deferred_cutoff_date
     , rct.org_id
     , rct.trx_number
     , rct.customer_trx_id
     , rct.trx_date
     , rctt.type trx_type
     , (SELECT SUM (aps1.amount_due_remaining)
        FROM   apps.ar_payment_Schedules_All aps1
        WHERE  aps1.customer_trx_id = rct.customer_trx_id)
          open_amount
     , (select  sum(yrctlgd.acctd_amount)
 from  apps.ra_cust_trx_line_gl_dist_all yrctlgd, apps.ra_customer_trx_lines_all yrctl
 where  yrctlgd.account_class = 'REV'
 and  yrctlgd.posting_control_id = -3
 and     yrctlgd.customer_trx_line_id = yrctl.customer_trx_line_id
 and  yrctl.customer_trx_id = rct.customer_trx_id
 and  yrctl.line_type = 'LINE'
 and  yrctl.accounting_rule_id = 1003
 and     yrctlgd.original_gl_date >= trunc(to_date('10012014','MMDDYYYY'))
 and    nvl(yrctlgd.account_set_flag,'N') <> 'Y') deferred_amount         
     , (select sum(aps2.amount_due_original)
                FROM   apps.ar_payment_Schedules_All aps2
        WHERE  aps2.customer_trx_id = rct.customer_trx_id) total_invoice_amount
FROM   apps.ra_customer_trx_all rct, apps.ra_cust_trx_types_all rctt
WHERE  rct.org_id in 
--and    rct.trx_date < trunc(to_date('10012014','MMDDYYYY'))
AND rctt.cust_trx_type_id = rct.cust_trx_type_id
and rctt.org_id = rct.org_id
AND    (SELECT sum(aps.amount_due_remaining)
           FROM   apps.ar_payment_Schedules_All aps
           WHERE  rct.customer_trx_id = aps.customer_trx_id) <> 0


--------------------Query to get NO Open Invoices/CM for Deferred dates (Deferred Invoices/CM have also Immediate lines)

SELECT 'NO OPEN A/R', 'FUTURE DEFERRED' deferred_or_regular
     , trunc(to_date('10012014','MMDDYYYY')) deferred_cutoff_date
     , rct.org_id
     , rct.trx_number
     , rct.customer_trx_id
     , rct.trx_date
     , rctt.type trx_type
     , (SELECT SUM (aps1.amount_due_remaining)
        FROM   apps.ar_payment_Schedules_All aps1
        WHERE  aps1.customer_trx_id = rct.customer_trx_id)
          open_amount
     , (select  sum(yrctlgd.acctd_amount)
 from  apps.ra_cust_trx_line_gl_dist_all yrctlgd, apps.ra_customer_trx_lines_all yrctl
 where  yrctlgd.account_class = 'REV'
 and  yrctlgd.posting_control_id = -3
 and     yrctlgd.customer_trx_line_id = yrctl.customer_trx_line_id
 and  yrctl.customer_trx_id = rct.customer_trx_id
 and  yrctl.line_type = 'LINE'
 and  yrctl.accounting_rule_id = 1003
 and     yrctlgd.original_gl_date >= trunc(to_date('10012014','MMDDYYYY'))
 and    nvl(yrctlgd.account_set_flag,'N') <> 'Y') deferred_amount
     , (select sum(aps2.amount_due_original)
                FROM   apps.ar_payment_Schedules_All aps2
        WHERE  aps2.customer_trx_id = rct.customer_trx_id) total_invoice_amount
FROM   apps.ra_customer_trx_all rct, apps.ra_cust_trx_types_all rctt
WHERE  rct.org_id in 
--and    rct.trx_date < trunc(to_date('10012014','MMDDYYYY'))
AND rctt.cust_trx_type_id = rct.cust_trx_type_id
and rctt.org_id = rct.org_id
AND     (SELECT sum(aps.amount_due_remaining)
           FROM   apps.ar_payment_Schedules_All aps
           WHERE  rct.customer_trx_id = aps.customer_trx_id) = 0
AND    EXISTS
          (SELECT NULL
           FROM   apps.ra_customer_trx_lines_All rctl1
           WHERE  rctl1.customer_trx_id = rct.customer_Trx_id
           AND    rctl1.accounting_rule_id = 1003)          
and  (select  sum(rctlgd.acctd_amount)
 from  apps.ra_cust_trx_line_gl_dist_all rctlgd, apps.ra_customer_trx_lines_all rctl
 where  rctlgd.account_class = 'REV'
 and  rctlgd.posting_control_id = -3
 and     rctlgd.customer_trx_line_id = rctl.customer_trx_line_id
 and  rctl.customer_trx_id = rct.customer_trx_id
 and  rctl.line_type = 'LINE'
 and  rctl.accounting_rule_id = 1003
 and     rctlgd.original_gl_date >= trunc(to_date('10012014','MMDDYYYY'))

 and    nvl(rctlgd.account_set_flag,'N') <> 'Y') <> 0;

----------------Query to get all the Installment Invoices

SELECT   a."CONV_TYPE",
            a."DEFERRED_OR_REGULAR",
            a."DEFERRED_CUTOFF_DATE",
            a."ORG_ID",
            a."TRX_NUMBER",
            a."CUSTOMER_TRX_ID",
            a."TRX_DATE",
            a."TRX_TYPE",
            a."OPEN_AMOUNT",
            a."DEFERRED_AMOUNT",
            a."TOTAL_INVOICE_AMOUNT",
            'inst'
     FROM   apps.tabs_gaia_ar_conv_header_mv a
    WHERE       a.org_id = 
            AND (SELECT   NVL (COUNT ( * ), 0)
                   FROM   ra_terms_lines rtl, ra_customer_trx_all rct
                  WHERE   rct.customer_trx_id = a.customer_trx_id
                          AND rtl.term_id = rct.term_id) > 1
            AND NVL (open_amount, 0) > 0
            AND NVL (open_amount, 0) <> NVL (total_invoice_amount, 0);