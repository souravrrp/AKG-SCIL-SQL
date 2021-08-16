CelL               : XXAKG_ONT_REGION_BLOCK_CELL_M 
Block             : XXAKG_DISTRIBUTOR_BLOCK_M 
Retailer          :  XXAKG_RETAILERS_CELL_D 
Price Location : XXAKG_DIST_PRICE_LOCATIONS_ALL 

SELECT
*
FROM
APPS.XXAKG_ONT_REGION_BLOCK_CELL_M
WHERE 1=1
--JOINED BY ORG_ID, 
--FIND OUT REGION_NAME, BLOCK_NAME, CELL_NAME, ORGANIZATION_NAME 
--AND ORG_ID=85
--AND LEDGER_ID IS NOT NULL
--AND END_DATE_ACTIVE IS NOT NULL


SELECT
*
FROM
APPS.XXAKG_DISTRIBUTOR_BLOCK_M
WHERE 1=1
AND ORG_ID=83
AND CUSTOMER_NUMBER IN ('82070',
'33164',
'35082',
'35011',
'184009')
--JOIN BY HEADER_ID, CUSTOMER_ID AND LEDGER_ID
--FIND OUT CUSTOMER_NAME, CUSTOMER_NUMBER AND REGION NAME  AND ORGANIZAION_NAME
--SEARCH BY CUSTOMER NUMBER, ORG_ID

SELECT
*
FROM
APPS.XXAKG_DISTRIBUTOR_BLOCK_M
WHERE 1=1
AND ORG_ID=85
--JOINED BY ORG_ID, CUSTOMER_NUMBER, HEADER_ID
--FIND OUT CUSTOMER_NUMBER, REGION_NAME, 


SELECT
*
FROM
APPS.XXAKG_RETAILERS_CELL_D
--FIND OUT CUSTOMER_NUMBER, CELL_NAME, SHIP_SITE_LOCATION_NAME 
--SEARCH ITEM BY LINE_ID



SELECT
*
FROM
APPS.XXAKG_DIST_PRICE_LOCATIONS_ALL
--JOIN BY CUSTOMER_ID, HEADER_ID
--FIND OUT PRICE_LOCATION_NAME, PRICE_LOCATION_CODE

SELECT
*
FROM
APPS.XXAKG_ONT_REGION_BLOCK_CELL_M RBC,
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
APPS.XXAKG_RETAILERS_CELL_D RCD,
APPS.XXAKG_DIST_PRICE_LOCATIONS_ALL DPLA
WHERE 1=1
AND RBC.ORG_ID=85
AND DBM.HEADER_ID=DPLA.HEADER_ID
AND DBM.CUSTOMER_ID=DPLA.CUSTOMER_ID
AND DBM.CUSTOMER_NUMBER=RCD.CUSTOMER_NUMBER
AND CUSTOMER_NAME='SouravIT'

SELECT
RBC.REGION_NAME,
RBC.BLOCK_NAME TEAM,
RBC.CELL_NAME CELL,
TO_CHAR(HCA.CREATION_DATE,'DD-MON-YYYY') CREATION_DATE,
RBC.CUSTOMER_NUMBER CUSTOMER_ID,
RBC.CUSTOMER_NAME CUSTOMER_NAME,
RBC.STATUS,
RBC.REAILER ADDRESS
--RBC.*
FROM
APPS.XXAKG_REGION_BLOCK_CELL_V RBC
,APPS.HZ_CUST_ACCOUNTS HCA
WHERE 1=1
AND RBC.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID
AND RBC.ORG_ID=84
--AND RBC.CUSTOMER_NUMBER IN ('18542')

SELECT
*
FROM
APPS.XXAKG_REGION_BLOCK_CELL_V