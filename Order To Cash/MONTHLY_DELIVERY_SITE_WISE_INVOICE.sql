SELECT
DOH.CUSTOMER_NUMBER "Customer ID",
DOH.CUSTOMER_NAME,
DODL.ITEM_DESCRIPTION "Item Name",
--DOH.DO_NUMBER,
--SUM(DECODE (DODL.UOM_CODE, 'MTN', DODL.LINE_QUANTITY*20,
--                                        'BAG', DODL.LINE_QUANTITY,
--                                'Not Defined')) "Quantity",
SUM(NVL (LINE_QUANTITY, 0)) "Quantity",
OOL.UNIT_SELLING_PRICE "Rate",
ACSV.LOCATION_ADDRESS "Delivery Location"
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
APPS.OE_ORDER_LINES_ALL OOL,
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
APPS.XXAKG_AR_CUSTOMER_SITE_V ACSV
WHERE 1=1
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND OOL.LINE_ID=DODL.ORDER_LINE_ID
AND DOH.DO_NUMBER=OOL.SHIPMENT_PRIORITY_CODE
AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
AND OOL.SOLD_TO_ORG_ID=ACSV.CUSTOMER_ID
AND OOL.SHIP_TO_ORG_ID=ACSV.SHIP_TO_ORG_ID
--AND OOL.ACTUAL_SHIPMENT_DATE BETWEEN '15-OCT-2017' and '16-NOV-2017'
and TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'MON-RR')='NOV-17' 
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
AND DOH.CUSTOMER_NUMBER=:P_CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
and DBM.REGION_NAME IN ('Corporate North','Corporate South','Institutional','MES')
GROUP BY
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ITEM_DESCRIPTION,
--DOH.DO_NUMBER,
OOL.UNIT_SELLING_PRICE,
ACSV.LOCATION_ADDRESS 
ORDER BY DOH.CUSTOMER_NUMBER ASC