SELECT distinct 
--DBM.REGION_NAME,
to_char(CUST_ACCT.CREATION_DATE,'DD-MON-YYYY')CREATION_DATE,
          CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_ID,
          PARTY.PARTY_NAME CUSTOMER_NAME,
          CUST_ACCT.STATUS,
          PS.PARTY_SITE_NUMBER RETAILER_NUMBER,
           PARTY.ADDRESS1||PARTY.ADDRESS2||PARTY.ADDRESS3||PARTY.ADDRESS4||PARTY.CITY||PARTY.COUNTRY ADDRESS
 from APPS.HZ_CUST_ACCOUNTS CUST_ACCT,
 APPS.HZ_CUST_ACCT_SITES_ALL ACCT_USE,
-- apps.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
 APPS.HZ_PARTIES PARTY,
 APPS.HZ_PARTY_SITES PS
Where 1=1
--AND CUST_ACCT.ACCOUNT_NUMBER=DBM.CUSTOMER_NUMBER(+)
AND CUST_ACCT.CUST_ACCOUNT_ID = ACCT_USE.CUST_ACCOUNT_ID
and  PARTY.PARTY_ID=CUST_ACCT.PARTY_ID
AND ACCT_USE.PARTY_SITE_ID = PS.PARTY_SITE_ID
AND PS.IDENTIFYING_ADDRESS_FLAG='Y'
--AND ACCT_USE.ORG_ID=DBM.ORG_ID(+)
--AND CUST_ACCT.ACCOUNT_NUMBER='35009'
and ACCT_USE.ORG_ID=605
order by 3