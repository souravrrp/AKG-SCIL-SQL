/* Formatted on 8/28/2019 10:40:51 AM (QP5 v5.287) */
SELECT 
       DECODE (RCTT.TYPE,
               'PMT', 'PAYMENT',
               'CM', 'CREDIT MEMO',
               'INV', 'INVOICES',
               'DM', 'DEBIT MEMO',
               'Not Defined')
          "PAYMENT TYPE",
       RCTT.NAME TRANSACTION_TYPE,
       MAX(RGLD.GL_DATE) LAST_TRANSACTION_DATE
       --,RCT.*
       --,RCTL.*
       --,RCTT.*
       --,RGLD.*
  FROM APPS.RA_CUSTOMER_TRX_ALL RCT,
       APPS.RA_CUSTOMER_TRX_LINES_ALL RCTL,
       APPS.RA_CUST_TRX_TYPES_ALL RCTT,
       APPS.RA_CUST_TRX_LINE_GL_DIST_ALL RGLD,
       APPS.GL_CODE_COMBINATIONS GCC
 WHERE     1 = 1
       AND RCT.ORG_ID = 85
       --AND RCT.TRX_NUMBER = '419341684'
       --AND TO_CHAR (RGLD.GL_DATE, 'RRRR') = '2019'
       AND RCT.CUSTOMER_TRX_ID = RCTL.CUSTOMER_TRX_ID
       AND RCT.CUST_TRX_TYPE_ID = RCTT.CUST_TRX_TYPE_ID
       AND RCT.CUSTOMER_TRX_ID = RGLD.CUSTOMER_TRX_ID
       AND RGLD.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
       --AND TO_CHAR (RCT.CREATION_DATE, 'DD-MON-RR') = '27-AUG-19'
       AND NVL (RCT.COMPLETE_FLAG, 'Y') = 'Y'
       AND RGLD.ACCOUNT_CLASS = 'REV'
       GROUP BY
       RCTT.NAME,RCTT.TYPE

--------------------------------------------------------------------------------

SELECT
--NVL (SUM (ps.amount_due_remaining), 0) invoice_balance,
--RTA.ORG_ID,
--cust_acct.ACCOUNT_NUMBER CUTOMER_NUMBER,
--party.party_name CUSTOMER_NAME,
--cust_acct.ACCOUNT_NAME CUSTOMER_NAME ,
DECODE (RTT.TYPE, 'PMT', 'PAYMENT',
                             'CM', 'CREDIT MEMO',
                             'INV', 'INVOICES',
                             'DM', 'DEBIT MEMO',
                                'Not Defined') "PAYMENT TYPE",
--RTA.TRX_DATE,
--RTA.SET_OF_BOOKS_ID,
--RTA.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
--RTT.NAME,
--RTT.DESCRIPTION,
--RTT.TYPE,
--'(' || RGLD.AMOUNT || ')' AMOUNT,
MAX(RGLD.GL_DATE) MAX_DATE,
--cc.segment2 "Cost Centre" ,
--cc.segment1 || '-' || cc.segment2 || '-' || cc.segment3 || '-' || cc.segment4 "Account",
cc.segment3 "Natural Account",
ffvv.DESCRIPTION "Natural Account Name"
--cust_acct.ACCOUNT_NAME,
--ps.TRX_NUMBER,
--PS.TRX_DATE,
--rtla.description,
--loc.ADDRESS1 ADDRESS,
--fndu.user_name user_id
FROM
apps.ra_cust_trx_types_all rtt,
apps.ra_customer_trx_all rta,
apps.ra_customer_trx_lines_all rtla,
apps.ra_cust_trx_line_gl_dist_all rgld,
apps.gl_code_combinations cc,
apps.fnd_flex_values_vl ffvv,
apps.hz_cust_accounts cust_acct,
apps.ar_payment_schedules_all ps,
apps.hz_cust_acct_sites_all acct_site,
apps.hz_party_sites party_site,
APPS.HZ_PARTIES party,
apps.hz_locations loc,
apps.hz_cust_site_uses_all site_uses,
apps.fnd_user fndu
WHERE 1=1
--TRUNC (ps.gl_date) <= :p_as_of_date AND
--cust_acct.account_number = :p_account_number AND
AND ps.customer_id = cust_acct.cust_account_id
AND RTA.ORG_ID=85
AND ps.cust_trx_type_id = rtt.cust_trx_type_id
and rta.CUSTOMER_TRX_ID=rtla.CUSTOMER_TRX_ID
and party.party_id=party_site.party_id
--AND ps.trx_date <= :p_as_of_date
--AND ps.CLASS NOT IN ('CM', 'PMT')
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
AND ffvv.FLEX_VALUE=cc.segment3
and fndu.user_id=rta.LAST_UPDATED_BY
AND rgld.account_class = 'REV'
--and rta.TRX_NUMBER='419304164'
--AND cc.segment2='GHAT24'
--AND TO_CHAR (RGLD.GL_DATE, 'MON-RR') = 'JUL-19'
AND TO_CHAR (RGLD.GL_DATE, 'RRRR') = '2019'
--AND TO_CHAR (RGLD.GL_DATE, 'DD-MON-RR') = '17-JUN-19'
--and RGLD.GL_DATE BETWEEN '01-OCT-2016' AND '01-NOV-2017'
--and fndu.user_name in ('2087','21213')
--and rownum<=5
GROUP BY
RTT.TYPE
,cc.segment3
,ffvv.DESCRIPTION