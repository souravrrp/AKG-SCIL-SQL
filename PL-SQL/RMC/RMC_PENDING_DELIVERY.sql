---------------------------------RMC PENDING DELIVRY----------------------

SELECT
--OOH.ORDER_TYPE_ID,
OOH.ORDER_NUMBER,
OOL.ORDERED_ITEM,
OOL.ORDERED_QUANTITY,
OOL.ORDER_QUANTITY_UOM,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
TO_CHAR(OOH.ORDERED_DATE) ORDERED_DATE,
OOL.SHIP_FROM_ORG_ID ORGANIZATION_ID,
OOL.FLOW_STATUS_CODE,
--OOH.FLOW_STATUS_CODE ORDER_STATUS,
OOL.UNIT_SELLING_PRICE,
(OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY) AMOUNT
--,OOL.*
FROM
APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.OE_ORDER_LINES_ALL OOL
WHERE 1=1
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING'
AND OOH.FLOW_STATUS_CODE='BOOKED'
AND OOH.ORDER_TYPE_ID=1105
--AND TO_CHAR (OOH.ORDERED_DATE, 'MON-RR') = 'DEC-17'
AND TO_CHAR (OOH.ORDERED_DATE, 'MON-RR') = 'JAN-18'
AND OOL.ACTUAL_SHIPMENT_DATE IS NULL
AND OOL.SHIPMENT_PRIORITY_CODE IS NOT NULL
AND OOH.ORG_ID=84
--AND OOH.ORDER_NUMBER=:P_ORDER_NUMBER


---------------------------------RMC DO Generated----------------------

SELECT
DOH.ORG_ID,
TO_CHAR(DOH.DO_DATE) DO_DATE,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,
DOH.DO_STATUS,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
SUM(DODL.LINE_QUANTITY) QUANTITY,
DODL.UOM_CODE,
DODL.WAREHOUSE_ORG_CODE
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
--AND DOH.CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND DODL.ORDER_NUMBER=:P_ORDER_NUMBER
--AND DOH.DO_NUMBER='DO/MOU/13984'
AND DOH.DO_STATUS='GENERATED'
--AND DOH.DO_DATE<='01-OCT-2017'
--AND MOH.CONFIRMED_DATE BETWEEN '15-OCT-2017' and '16-NOV-2017'
AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'JAN-18'
AND DOH.ORG_ID=84
GROUP BY
DOH.ORG_ID,
TO_CHAR(DOH.DO_DATE),
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,
DOH.DO_STATUS,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
--SUM(DODL.LINE_QUANTITY) QUANTITY,
DODL.UOM_CODE,
DODL.WAREHOUSE_ORG_CODE
--ORDER BY DOH.DO_DATE DESC