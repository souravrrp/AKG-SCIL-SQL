SELECT DISTINCT 
ORDER_DTLS.PARTY_NAME, 
ORDER_DTLS.CUSTOMER_NUMBER, 
ORDER_DTLS.ORDER_NUMBER, 
ORDER_DTLS.ORDERED_DATE, 
ORDER_DTLS.LOCATION, 
ORDER_DTLS.SITE_USE_CODE, 
ORDER_DTLS.INVNO, 
ORDER_DTLS.INVDATE, 
ORDER_DTLS.SITNO 
FROM 
(SELECT HR.NAME OU, 
HP.PARTY_NAME, 
hzca.account_number CUSTOMER_NUMBER, 
ORDER_NUMBER,ordered_date, 
location, 
hzcst.site_use_code, 
INVOICE_DET.TRX_NUMBER INVNO, 
INVOICE_DET.TRX_DATE INVDATE,party_site.PARTY_SITE_NUMBER SITNO 
FROM APPS.hz_cust_accounts hzca, 
APPS.hz_party_sites party_site , 
APPS.hz_locations loc , 
APPS.hz_cust_acct_sites_all hzcs, 
APPS.hz_cust_site_uses_all hzcst, 
APPS.hz_parties hp, 
APPS.oe_order_headers_all OEH, 
APPS.HR_OPERATING_UNITS HR, 
(SELECT ct_reference,TRX_NUMBER,TRX_DATE FROM 
APPS.RA_CUSTOMER_TRX_ALL) INVOICE_DET 
WHERE hzca.cust_account_id = hzcs.cust_account_id 
AND hzcs.cust_acct_site_id =hzcst.cust_acct_site_id 
AND invoice_det.ct_reference(+)=to_char(ORDER_NUMBER) 
AND hzcs.party_site_id = party_site.party_site_id 
AND loc.location_id = party_site.location_id 
AND hzcs.cust_acct_site_id =hzcst.cust_acct_site_id 
AND hp.party_id = hzca.party_id 
AND hzcst.ORG_ID = HR.organization_id 
AND hzca.cust_account_id =OEH.sold_to_org_id 
AND hzcst.site_use_id =OEH.invoice_to_org_id --Invoice to 
AND hzcs.status = 'A' 
AND HZCST.STATUS = 'A' 
) ORDER_DTLS