SELECT
*
FROM
APPS.HZ_PARTIES HP
,APPS.HZ_CUST_ACCOUNTS HCA
,APPS.AP_SUPPLIERS APS
WHERE 1=1
AND HP.PARTY_ID=APS.PARTY_ID
AND HP.PARTY_ID=HCA.PARTY_ID
AND HCA.ACCOUNT_NUMBER='20057'
--and upper(HP.PARTY_NAME) like UPPER('%'||:P_PARTY_NAME||'%') 


SELECT
*
FROM
APPS.HZ_PARTIES HP
,APPS.HZ_CUST_ACCOUNTS HCA
,APPS.AP_SUPPLIERS APS
WHERE 1=1
AND HP.PARTY_ID=APS.PARTY_ID
AND HP.PARTY_ID=HCA.PARTY_ID
--AND HCA.ACCOUNT_NUMBER='20057'
--and upper(HP.PARTY_NAME) like UPPER('%'||:P_PARTY_NAME||'%') 
AND EXISTS( SELECT 1 FROM APPS.HZ_PARTIES HP,APPS.AP_SUPPLIERS APS WHERE HP.PARTY_ID=APS.PARTY_ID
--AND APS.SEGMENT1='20057'  
--and upper(HP.PARTY_NAME) like UPPER('%'||:P_PARTY_NAME||'%') 
)

SELECT
*
FROM
APPS.AP_SUPPLIERS APS