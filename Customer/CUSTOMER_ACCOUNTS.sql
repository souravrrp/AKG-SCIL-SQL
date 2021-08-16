SELECT
*
FROM
APPS.HZ_CUST_SITE_USES_ALL
WHERE 1=1
--CONDITIONED_BY SITE_USE_ID, SITE_USE_CODE, STATUS, CUST_ACCT_SITE_ID, ORIG_SYSTEM_REFERENCE
--FIND_OUT LOCATION
--SEARCH BY ORDER_TYPE 

SELECT
*
FROM
APPS.HZ_CUST_ACCT_SITES_ALL
WHERE 1=1
--CONDITIONED_BY STATUS, ORD_ID
--JOINED_BY CUST_ACCT_SITE_ID, CUST_ACCOUNT_ID, PARTY_SITE_ID, ORIG_SYSTEM_REFERENCE
--SEARCH_BY CREATION_DATE, 

SELECT
*
FROM
APPS.HZ_CUST_ACCOUNTS
WHERE 1=1
--JOINED BY  CUST_ACCOUNT_ID, PARTT_ID, ACCOUNT_NUMBER, ORIG_SYSTEM_REFERENCE
--CONDITIONED BY STATUS, 
--FIND OUT ACCOUNT_NAME

--------------------------------------------COMBINED----------------------------------------
SELECT
CA.ACCOUNT_NUMBER,
CA.ACCOUNT_NAME,
CA.STATUS ACCOUNT_STATUS,
CSUA.STATUS CUSTOMER_SITE_STATUS,
CA.CREATION_DATE "ACCOUNT CREATION DATE",
CASA.CREATION_DATE "ACCOUNT SITE CREATION DATE",
CSUA.SITE_USE_CODE,
CSUA.LOCATION
FROM
APPS.HZ_CUST_ACCOUNTS CA,
APPS.HZ_CUST_SITE_USES_ALL CSUA,
APPS.HZ_CUST_ACCT_SITES_ALL CASA
WHERE 1=1
--AND CA.ORIG_SYSTEM_REFERENCE=CSUA.ORIG_SYSTEM_REFERENCE
AND CSUA.CUST_ACCT_SITE_ID=CASA.CUST_ACCT_SITE_ID
AND CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID
AND CA.STATUS='A'
AND CSUA.STATUS='A'

-----------------------------------****DUMMY****---------------------------------------
select
HCA.CUST_ACCOUNT_ID,
HCA.ORIG_SYSTEM_REFERENCE,
HCA.ACCOUNT_NUMBER,
HCA.CREATION_DATE,
HCA.CREATED_BY,
HCA.ATTRIBUTE1 Credit_Limit,
HCA.ATTRIBUTE2 Additional_Credit_Limit,
HCA.ATTRIBUTE3 SP_Credit_Limit,
HCA.ATTRIBUTE4 Instrument_type,
HCA.ATTRIBUTE7 Old_Lagacy_Number,
HCA.STATUS,
HCA.CUSTOMER_CLASS_CODE,
HCA.ACCOUNT_NAME,
--HP.PARTY_NAME,
--HP.PARTY_NUMBER,
--HP.PARTY_ID_1,
HP.PARTY_TYPE,
--HP.LAST_UPDATED_BY_1,
--HP.LAST_UPDATE_DATE_1,
HP.CUSTOMER_KEY,
HP.COUNTRY,
HP.ADDRESS1,
HP.ADDRESS2,
HP.ADDRESS3,
HP.ADDRESS4,
HP.CITY,
HP.CURR_FY_POTENTIAL_REVENUE Annual_Revenue,
HP.CATEGORY_CODE,
--HP.SALES_CHANNEL_CODE,
hl_ship.address1 ||Decode(hl_ship.address2,NULL,'',chr(10))
||hl_ship.address2||Decode(hl_ship.address3,NULL,'', chr(10))
||hl_ship.address3||Decode(hl_ship.address4,NULL,'', chr(10))
||hl_ship.address4||Decode(hl_ship.city,NULL,'',chr( 10))
||hl_ship.city ||Decode(hl_ship.state,NULL,'',',')
||hl_ship.state ||Decode(hl_ship.postal_code,'',',')
||hl_ship.postal_code ship_to_address,
hl_bill.address1 ||Decode(hl_bill.address2,NULL,'',chr(10))
||hl_bill.address2||Decode(hl_bill.address3,NULL,'', chr(10))
||hl_bill.address3||Decode(hl_bill.address4,NULL,'', chr(10))
||hl_bill.address4||Decode(hl_bill.city,NULL,'',chr( 10))
||hl_bill.city ||Decode(hl_bill.state,NULL,'',',')
||hl_bill.state ||Decode(hl_bill.postal_code,'',',')
||hl_bill.postal_code bill_to_address,
hca_bill.TERRITORY_ID,
hca_bill.TERRITORY,
terr.SEGMENT2 Division,
terr.SEGMENT3 Region,
hps_bill.PARTY_SITE_NUMBER SITE_NUMBER,
hps_bill.PARTY_SITE_NAME Site_Name
from 
 apps.hz_cust_accounts HCA ,apps.hz_parties HP,
apps.hz_cust_site_uses_all hcs_ship
, apps.hz_cust_acct_sites_all hca_ship
, apps.hz_party_sites hps_ship
, apps.hz_parties hp_ship
, apps.hz_locations hl_ship
, apps.hz_cust_site_uses_all hcs_bill
, apps.hz_cust_acct_sites_all hca_bill
, apps.hz_party_sites hps_bill
, apps.hz_parties hp_bill
, apps.hz_locations hl_bill
,apps.ra_territories terr
,APPS.OE_ORDER_HEADERS_ALL OOH
where 
HP.party_id=HCA.party_id
AND ooh.ship_to_org_id = hcs_ship.site_use_id
AND hcs_ship.cust_acct_site_id = hca_ship.cust_acct_site_id
AND hca_ship.party_site_id = hps_ship.party_site_id
AND hps_ship.party_id = hp_ship.party_id
AND hps_ship.location_id = hl_ship.location_id
AND ooh.invoice_to_org_id = hcs_bill.site_use_id
AND hcs_bill.cust_acct_site_id = hca_bill.cust_acct_site_id
AND hca_bill.party_site_id = hps_bill.party_site_id
AND hps_bill.party_id = hp_bill.party_id
AND hps_bill.location_id = hl_bill.location_id
and terr.TERRITORY_ID=hca_bill.TERRITORY_ID
--and HP.party_id='332942'
--and ooh.order_number='1683334'
