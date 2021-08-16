SELECT
DBM.REGION_NAME,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) ACTUAL_DO_QUANTITY,
(CASE WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 1 AND 104 THEN 100
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 105 AND 208 THEN 200
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 208 AND 312 THEN 300
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 312 AND 416 THEN 400
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 416 AND 520 THEN 500
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 520 AND 624 THEN 600
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 624 AND 728 THEN 700
           WHEN SUM(DODL.LINE_QUANTITY)  BETWEEN 724 AND 832 THEN 800
           ELSE SUM(DODL.LINE_QUANTITY)
END) "APPROXIMATE QUANTITY in BAG", 
DODL.UOM_CODE
FROM
APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.OE_ORDER_LINES_ALL OOL
,APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
,APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM
WHERE 1=1
AND DOH.ORG_ID=85
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.LINE_ID=DODL.ORDER_LINE_ID
AND DODL.DO_NUMBER=OOL.SHIPMENT_PRIORITY_CODE
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'OCT-17'
AND OOL.ACTUAL_SHIPMENT_DATE BETWEEN '15-NOV-2017' and '19-NOV-2017'
GROUP BY
DBM.REGION_NAME,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,
DODL.UOM_CODE
