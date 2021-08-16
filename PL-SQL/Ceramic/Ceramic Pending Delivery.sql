SELECT DISTINCT
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
SUM(OOL.ORDERED_QUANTITY) QUANTITY,
MOH.MOV_ORDER_NO,
DOH.MODE_OF_TRANSPORT,
MOH.TRANSPORTER_NAME,
CAT.DESCRIPTION,
CAT.CATEGORY_CODE ITEM_CATEGORY
FROM 
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT,
APPS.OE_ORDER_LINES_ALL OOL,
XXAKG.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_BIEE_ORGITEMMASTER CAT
WHERE 1=1
AND OOL.SHIP_FROM_ORG_ID=CAT.ORGANIZATION_ID
AND OOL.ORDERED_ITEM=CAT.ITEM_CODE
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND MODT.CUSTOMER_NUMBER=DOH.CUSTOMER_NUMBER
AND DOH.DO_NUMBER=OOL.SHIPMENT_PRIORITY_CODE
AND DBM.REGION_NAME!='Scrap'
AND DBM.CUSTOMER_NUMBER=DOH.CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
AND DOH.ORG_ID=83
AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING'
AND DOH.DO_STATUS='CONFIRMED'
AND MOH.MOV_ORDER_STATUS='CONFIRMED'
AND EXISTS (SELECT 1 FROM APPS.WSH_DELIVERABLES_V WSHD WHERE WSHD.SOURCE_LINE_ID=OOL.LINE_ID AND WSHD.RELEASED_STATUS_NAME IN ('Ready to Release','Staged/Pick Confirmed','Shipped'))
--AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2018'
AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'JUL-18'
AND TO_CHAR (MOH.CONFIRMED_DATE, 'MON-RR') = 'JUL-18'
GROUP BY 
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
MOH.MOV_ORDER_NO,
DOH.MODE_OF_TRANSPORT,
MOH.TRANSPORTER_NAME,
CAT.DESCRIPTION,
CAT.CATEGORY_CODE

------------------------------------------------------------------------------------------------

SELECT
DOH.ORG_ID,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
ool.ORDERED_QUANTITY,
OOL.FLOW_STATUS_CODE Order_Line_Status,
dodl.DO_NUMBER,
DODL.LINE_QUANTITY DO_QUANTITY,
TO_CHAR (DOH.DO_DATE, 'DD-MON-YYYY') DO_DATE,
DOH.DO_STATUS,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
DODL.UOM_CODE "UNIT OF MEASURE",
--OOL.SHIP_FROM_ORG_ID,
--DODL.WAREHOUSE_ORG_ID,
DODL.WAREHOUSE_ORG_CODE
from
APPS.OE_ORDER_LINES_ALL OOL
,APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND DOH.ORG_ID=83
AND OOL.ORDERED_ITEM_ID=DODL.ORDERED_ITEM_ID
--AND OOL.SHIP_FROM_ORG_ID=DODL.WAREHOUSE_ORG_ID
AND OOL.SHIP_TO_ORG_ID=DODL.SHIP_TO_ORG_ID
--AND DODL.DO_NUMBER='DO/SCOU/876006'
AND OOL.SHIPMENT_PRIORITY_CODE=DOH.DO_NUMBER
AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING'
AND OOL.FLOW_STATUS_CODE!='CANCELLED'
AND DOH.DO_STATUS='CONFIRMED'
AND DODL.UOM_CODE IN ('BAG','MTN')
AND DODL.ORDER_HEADER_ID=OOL.HEADER_ID
--AND DODL.ORDER_LINE_ID=OOL.LINE_ID
AND DODL.DO_HDR_ID=DOH.DO_HDR_ID
AND OOL.ACTUAL_SHIPMENT_DATE IS NULL
AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'APR-18'  
--AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2017'
--AND DOH.DO_DATE<='30-NOV-2017'-- between '01-JAN-2017' and '31-OCT-2017'
ORDER BY DOH.DO_DATE DESC

-------------------------------********************----------------------------------


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
AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING' --IN ('SHIPPED','CLOSED')--='AWAITING_SHIPPING'
--AND OOH.FLOW_STATUS_CODE='BOOKED'
--AND OOH.ORDER_TYPE_ID=1099
--AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'FEB-18'
--AND TO_CHAR (OOH.ORDERED_DATE, 'RRRR') = '2017'
--AND OOL.ACTUAL_SHIPMENT_DATE IS NOT NULL
AND OOL.SHIPMENT_PRIORITY_CODE IS NOT NULL
AND OOL.ACTUAL_SHIPMENT_DATE IS NULL  
AND OOH.ORG_ID=85
--AND OOH.ORDER_NUMBER=:P_ORDER_NUMBER
AND EXISTS (SELECT 1 FROM APPS.XXAKG_DEL_ORD_HDR DOH, APPS.XXAKG_DEL_ORD_DO_LINES DODL 
                    WHERE DOH.DO_HDR_ID=DODL.DO_HDR_ID AND DODL.ORDER_NUMBER=OOH.ORDER_NUMBER
                    AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'JUL-18'  
                    --AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2017'
                    )
