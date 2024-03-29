SELECT
NVL(RBC.REGION_NAME,'Unspecified') REGION_NAME,
RBC.BLOCK_NAME,
--RBC.CELL_NAME,
PARTY.CATEGORY_CODE CUSTOMER_CATEGORY,
PARTY.PARTY_NAME CUSTOMER_NAME,
CA.ACCOUNT_NUMBER CUSTOMER_NUMBER,
(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=OOL.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=OOL.SHIP_FROM_ORG_ID) ITEM_CODE,
OOH.ORDER_NUMBER,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
SUM(OOL.SHIPPED_QUANTITY) SHIPPED_QUANTITY,
(SUM(OOL.SHIPPED_QUANTITY)*OOL.UNIT_SELLING_PRICE) SHIPPED_AMOUNT
,DECODE (party.category_code, 'DISTRIBUTOR', 8*SUM(OOL.SHIPPED_QUANTITY), 'DEALER', 8*SUM(OOL.SHIPPED_QUANTITY), 'PRIME SELLER', DECODE (ca.sales_channel_code, 'DHAKA', 6*SUM(OOL.SHIPPED_QUANTITY), '-1',7*SUM(OOL.SHIPPED_QUANTITY),NULL),NULL) Commission_Amount
--,DBM.*
FROM
APPS.HZ_PARTIES PARTY,
APPS.HZ_CUST_ACCOUNTS CA,
--APPS.HZ_CUST_SITE_USES_ALL CSUA,
--APPS.HZ_CUST_ACCT_SITES_ALL CASA,
APPS.XXAKG_REGION_BLOCK_CELL_V RBC
,APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.OE_ORDER_LINES_ALL OOL
WHERE 1=1
AND RBC.ORG_ID=OOH.ORG_ID
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.SOLD_TO_ORG_ID=CA.CUST_ACCOUNT_ID
AND RBC.SHIP_SITE_LOCATION_ID=OOL.SHIP_TO_ORG_ID
AND PARTY.PARTY_ID=CA.PARTY_ID
AND CA.ACCOUNT_NUMBER=RBC.CUSTOMER_NUMBER(+)
--AND CSUA.CUST_ACCT_SITE_ID=CASA.CUST_ACCT_SITE_ID
--AND CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID
--AND nvl(ca.status,'X')='A'
--AND CA.STATUS='A'
--AND CA.ACCOUNT_NUMBER=:P_CUSTOMER_NUM
--AND OOL.SHIPMENT_PRIORITY_CODE=:P_DO_NUMBER
AND TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'DD-MON-RR')='20-MAR-18'
--AND CSUA.SITE_USE_CODE='BILL_TO'
AND RBC.ORG_ID(+)=85
AND RBC.REGION_NAME IN ('Gazipur','Dhaka South','Mymensingh','Rajshahi','Sylhet','Rangpur','Prime Seller','Comilla','Faridpur','Dhaka North','Narayangonj','Khulna','Barisal','Tangail','Bogra','Noakhali','Chittagong')
AND EXISTS (SELECT 1 FROM APPS.HZ_CUST_ACCT_SITES_ALL CASA WHERE CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID AND OOH.ORG_ID=CASA.ORG_ID AND CASA.ORG_ID=85)
GROUP BY
NVL(RBC.REGION_NAME,'Unspecified'),
RBC.BLOCK_NAME,
--RBC.CELL_NAME,
PARTY.CATEGORY_CODE,
PARTY.PARTY_NAME,
CA.ACCOUNT_NUMBER,
ca.sales_channel_code,
OOL.INVENTORY_ITEM_ID,
OOL.UNIT_SELLING_PRICE,
OOL.SHIP_FROM_ORG_ID,
OOH.ORDER_NUMBER,
OOL.SHIPMENT_PRIORITY_CODE

-----------------SHORT_CUT----------------------------------------------------------------


SELECT
NVL(RBC.REGION_NAME,'Unspecified') REGION_NAME,
RBC.BLOCK_NAME,
RBC.CELL_NAME,
PARTY.CATEGORY_CODE CUSTOMER_CATEGORY,
PARTY.PARTY_NAME CUSTOMER_NAME,
CA.ACCOUNT_NUMBER CUSTOMER_NUMBER,
(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=ORD.ORDERED_ITEM_ID AND MSI.ORGANIZATION_ID=ORD.SHIP_FROM_ORG_ID) ITEM_CODE,
ORD.ORDER_NUMBER,
ORD.DO_NUMBER,
SUM(ORD.ORDERED_AMT) SHIPPED_QUANTITY,
SUM(ORD.ORDERED_AMT) SHIPPED_AMOUNT
,DECODE (party.category_code, 'DISTRIBUTOR', 8*SUM(ORD.SHIPPED_QUANTITY), 'DEALER', 8*SUM(ORD.SHIPPED_QUANTITY), 'PRIME SELLER', DECODE (ca.sales_channel_code, 'DHAKA', 6*SUM(ORD.SHIPPED_QUANTITY), '-1',7*SUM(ORD.SHIPPED_QUANTITY),NULL),NULL) Commission_Amount
----,DBM.*
FROM
APPS.HZ_PARTIES PARTY,
APPS.HZ_CUST_ACCOUNTS CA,
--APPS.HZ_CUST_SITE_USES_ALL CSUA,
--APPS.HZ_CUST_ACCT_SITES_ALL CASA,
APPS.XXAKG_REGION_BLOCK_CELL_V RBC
,APPS.XXAKG_HEADER_DETAIL_V ORD
WHERE 1=1
AND RBC.ORG_ID=ORD.ORG_ID
AND ORD.SOLD_TO_ORG_ID=CA.CUST_ACCOUNT_ID
AND RBC.SHIP_SITE_LOCATION_ID=ORD.SHIP_TO_ORG_ID
AND PARTY.PARTY_ID=CA.PARTY_ID
AND CA.ACCOUNT_NUMBER=RBC.CUSTOMER_NUMBER(+)
--AND CSUA.CUST_ACCT_SITE_ID=CASA.CUST_ACCT_SITE_ID
--AND CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID
--AND nvl(ca.status,'X')='A'
--AND CA.STATUS='A'
--AND CA.ACCOUNT_NUMBER=:P_CUSTOMER_NUM
--AND ORD.DO_NUMBER=:P_DO_NUMBER
--AND TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'DD-MON-RR')='20-MAR-18'
--AND CSUA.SITE_USE_CODE='BILL_TO'
AND RBC.ORG_ID(+)=85
AND RBC.REGION_NAME IN ('Gazipur','Dhaka South','Mymensingh','Rajshahi','Sylhet','Rangpur','Prime Seller','Comilla','Faridpur','Dhaka North','Narayangonj','Khulna','Barisal','Tangail','Bogra','Noakhali','Chittagong')
AND EXISTS (SELECT 1 FROM APPS.HZ_CUST_ACCT_SITES_ALL CASA WHERE CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID AND ORD.ORG_ID=CASA.ORG_ID AND CASA.ORG_ID=85)
GROUP BY
NVL(RBC.REGION_NAME,'Unspecified'),
RBC.BLOCK_NAME,
RBC.CELL_NAME,
PARTY.CATEGORY_CODE,
PARTY.PARTY_NAME,
CA.ACCOUNT_NUMBER,
ca.sales_channel_code,
ORD.ORDERED_ITEM_ID,
ORD.UNIT_SELLING_PRICE,
ORD.SHIP_FROM_ORG_ID,
ORD.ORDER_NUMBER,
ORD.DO_NUMBER