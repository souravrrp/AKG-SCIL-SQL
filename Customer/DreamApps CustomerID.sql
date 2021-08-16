SELECT 
--HOU.NAME ORGANIZATION,
--RBC.REGION_NAME,
--RBC.BLOCK_NAME,
A.CUSTOMER_NUMBER "Customer ID", 
NVL(HCA.ATTRIBUTE7,'No DreamApps ID') "Old Legacy Number",
A.CUSTOMER_NAME "Party Name",
A.ADDRESS1 "Address",
A.ADDRESS3 "Proprietor Name",
--RBC.PHONE_NUMBER,
--(SELECT HCP.PHONE_NUMBER
--            FROM APPS.HZ_PARTIES HP,APPS.HZ_RELATIONSHIPS HR,APPS.HZ_PARTIES H_CONTACT ,APPS.HZ_CONTACT_POINTS HCP,APPS.HZ_CUST_ACCOUNTS CUST,APPS.AR_CONTACTS_V ARC
--            WHERE CUST.ACCOUNT_NUMBER=A.CUSTOMER_NUMBER AND ARC.CUSTOMER_ID=CUST.CUST_ACCOUNT_ID AND HR.SUBJECT_ID = H_CONTACT.PARTY_ID AND HR.OBJECT_ID = HP.PARTY_ID
--            AND HCP.OWNER_TABLE_ID(+) = HR.PARTY_ID AND CUST.PARTY_ID = HP.PARTY_ID AND HCP.CONTACT_POINT_TYPE ='PHONE' AND HCP.STATUS = 'A'-- AND ARC.JOB_TITLE IS NULL
--            AND HR.RELATIONSHIP_ID=ARC.PARTY_RELATIONSHIP_ID AND HCP.OWNER_TABLE_NAME='HZ_PARTIES') Contact_NO,
A.STATUS
--,A.*
--,HCA.* 
--,RBC.*
FROM
APPS.XXAKG_AR_CUSTOMER_SITE_V A,
APPS.XXAKG_REGION_BLOCK_CELL_V RBC,
APPS.HZ_CUST_ACCOUNTS HCA,
APPS.HR_OPERATING_UNITS HOU
WHERE 1=1
AND A.CUSTOMER_ID=RBC.CUSTOMER_ID
AND A.PARTY_SITE_NUMBER=RBC.PARTY_SITE_NUMBER
--AND A.SITE_USE_ID=RBC.SHIP_SITE_LOCATION_ID
AND A.ORG_ID=85
AND HOU.ORGANIZATION_ID=A.ORG_ID
AND A.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID
AND SITE_USE_CODE = 'BILL_TO'
--AND SITE_USE_CODE = 'SHIP_TO'
--AND A.SHIP_TO_ORG_ID='34777'
--AND A.PRIMARY_FLAG='Y'
AND SITE_USE_STATUS='A'
--AND A.STATUS = 'A'
AND A.CUSTOMER_NUMBER IN ('20078')
--AND RBC.PHONE_NUMBER IS NOT NULL
--AND A.CUSTOMER_NAME LIKE '%International%Institute%of%Maritime%Technology%'
--AND UPPER(A.CUSTOMER_NAME) LIKE UPPER('%'||:P_CUST_NAME||'%') 
ORDER BY 2 DESC


-----------------------------****Customer****-------------------------------------------
SELECT 
HOU.NAME ORGANIZATION,
CA.ACCOUNT_NUMBER,
--HP.PARTY_NAME CUSTOMER_NAME,
CA.ACCOUNT_NAME,
CA.STATUS ACCOUNT_STATUS,
CSUA.STATUS CUSTOMER_SITE_STATUS,
CA.CREATION_DATE "ACCOUNT CREATION DATE",
CASA.CREATION_DATE "ACCOUNT SITE CREATION DATE",
CSUA.SITE_USE_CODE,
CSUA.SITE_USE_ID PARTY_SITE_NUMBER,
CSUA.LOCATION
,CA.* 
--,CASA.*
--,CSUA.*
--,HOU.*
--,HP.*
--,HPS.*
--,LOC.*
--,RBC.*
FROM
APPS.XXAKG_REGION_BLOCK_CELL_V RBC,
APPS.HZ_CUST_ACCOUNTS CA,
APPS.HZ_CUST_SITE_USES_ALL CSUA,
APPS.HZ_CUST_ACCT_SITES_ALL CASA
,APPS.HR_OPERATING_UNITS HOU
--,APPS.HZ_PARTIES HP
--,APPS.HZ_PARTY_SITES HPS
--,APPS.HZ_LOCATIONS LOC
WHERE 1=1 
--AND CASA.ORIG_SYSTEM_REFERENCE=RBC.PARTY_SITE_NUMBER
AND CA.CUST_ACCOUNT_ID=RBC.CUSTOMER_ID
AND CSUA.CUST_ACCT_SITE_ID=CASA.CUST_ACCT_SITE_ID
AND CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID
--AND CA.STATUS='A'
AND CSUA.STATUS='A'
AND ORGANIZATION_ID=CASA.ORG_ID
--AND HP.PARTY_ID=CA.PARTY_ID
--AND HPS.PARTY_ID = HP.PARTY_ID
--AND HPS.LOCATION_ID = LOC.LOCATION_ID
--AND HP.STATUS='A'
--AND HPS.STATUS='A'
--AND HPS.IDENTIFYING_ADDRESS_FLAG='Y'
--AND CASA.ORG_ID = 85
AND SITE_USE_CODE = 'BILL_TO'
--AND CSUA.BILL_TO_SITE_USE_ID='37644'
--AND CSUA.SITE_USE_ID='34777'
--AND SITE_USE_CODE = 'SHIP_TO'
--AND PRIMARY_FLAG='N'
--AND STATUS = 'A'
--AND UPPER(CA.ACCOUNT_NAME) LIKE UPPER('%'||:P_CUST_NAME||'%') 
AND ACCOUNT_NUMBER IN ('20078')
--ORDER BY ACCOUNT_NUMBER DESC