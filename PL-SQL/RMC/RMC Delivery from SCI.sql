SELECT
--ORGANIZATION_NAME,
--ORGANIZATION_CODE,
ACSV.CUSTOMER_NUMBER,
ACSV.CUSTOMER_NAME,
--ORDERED_DATE,
--ORDER_NUMBER,
(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=ORD.ORDERED_ITEM_ID AND MSI.ORGANIZATION_ID=ORD.SHIP_FROM_ORG_ID) ITEM_NAME,
ORDERED_ITEM,
--ORDER_QUANTITY_UOM,
--UNIT_SELLING_PRICE,
--UNIT_LIST_PRICE,
--ORDERED_QUANTITY,
SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', INVOICED_QUANTITY*20,
                                        'BAG', ORDERED_QUANTITY)) ORDERED_QUANTITY_BAG,
SUM(ORDERED_QUANTITY) ORD_QUANTITY,
--SUM(INVOICED_QUANTITY) QUANTITY,
SUM(ORDERED_AMT) AMOUNT
--DELIVERY_DATE,
--FLOW_STATUS_CODE,
--DO_NUMBER,
,PERIOD
--,ORD.*
FROM
APPS.XXAKG_HEADER_DETAIL_V ORD
,APPS.XXAKG_AR_CUSTOMER_SITE_V ACSV 
WHERE 1=1
AND ORD.ORG_ID=85
AND ACSV.CUSTOMER_ID=ORD.SOLD_TO_ORG_ID
AND ACSV.SHIP_TO_ORG_ID=ORD.SHIP_TO_ORG_ID
AND PERIOD='MAY-19'
AND FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
--AND ORGANIZATION_CODE='G32'
AND ACSV.STATUS='A'
--AND ACSV.SITE_USE_CODE='BILL_TO'
--AND ACSV.SITE_USE_CODE='SHIP_TO'
--AND ACSV.PRIMARY_FLAG='Y'
AND ACSV.SITE_USE_STATUS='A'
AND ACSV.ACCT_USE_STATUS='A'
--AND NOT EXISTS (SELECT 1 FROM APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM WHERE 1=1 AND  ACSV.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER )
AND CUSTOMER_NUMBER IN ('23809','23848')--=:P_CUSTOMER_NUMBER
--AND ORD.ORDER_NUMBER IN ('1659352')
--AND ORD.DO_NUMBER=:P_DO_NUMBER
--AND TO_CHAR(DELIVERY_DATE,'RRRR')='2018'
GROUP BY
ORDERED_ITEM
,PERIOD
,ORD.ORDERED_ITEM_ID 
,ORD.SHIP_FROM_ORG_ID
,ACSV.CUSTOMER_NAME
,ACSV.CUSTOMER_NUMBER