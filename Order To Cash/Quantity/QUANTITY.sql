SELECT DISTINCT
OOL.ORDERED_ITEM,
OOL.ORDERED_QUANTITY,
OOL.CANCELLED_QUANTITY,
DO_Details.DO_QUANTITY,
OOL.SHIPPING_QUANTITY,
OOL.SHIPPED_QUANTITY,
OOL.INVOICED_QUANTITY
FROM 
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH,
(
SELECT 
DOH.ORG_ID,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.ORDER_NUMBER,
            DOH.DO_NUMBER,
            SUM (LINE_QUANTITY) DO_QUANTITY,
            DODL.DO_HDR_ID,
            DODL.ORDER_HEADER_ID,
            DODL.ORDER_LINE_ID
             FROM 
             XXAKG.XXAKG_DEL_ORD_DO_LINES DODL,
             APPS.XXAKG_DEL_ORD_HDR DOH
            WHERE DODL.DO_HDR_ID = DOH.DO_HDR_ID
--            AND DOH.DO_NUMBER='DO/SCOU/21804'
            AND DOH.DO_STATUS='GENERATED'
            GROUP BY DOH.DO_NUMBER, DODL.DO_HDR_ID, DODL.ORDER_HEADER_ID, DODL.ORDER_LINE_ID
            
            
            
            ) DO_Details
WHERE 1=1
AND OOH.ORG_ID=85
AND OOL.HEADER_ID(+)=OOH.HEADER_ID
--AND OOH.HEADER_ID=DO_Details.ORDER_HEADER_ID(+)
--AND OOL.LINE_ID=DO_Details.ORDER_LINE_ID(+)
AND OOH.ORDER_NUMBER='1639185'
--AND DO_Details.DO_NUMBER='DO/SCOU/1015006'
--AND ROWNUM<=2
GROUP BY  
OOL.ORDERED_ITEM,
OOL.ORDERED_QUANTITY,
OOL.CANCELLED_QUANTITY,
DO_Details.DO_QUANTITY,
OOL.SHIPPING_QUANTITY,
OOL.SHIPPED_QUANTITY,
OOL.INVOICED_QUANTITY


SELECT
OOH.HEADER_ID,
OOL.LINE_ID,
OOL.ORDERED_ITEM,
OOH.ORDER_NUMBER,
OOL.ORDERED_QUANTITY,
OOL.FLOW_STATUS_CODE
FROM 
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
WHERE 1=1
AND OOH.ORG_ID=85
--AND OOL.SHIPMENT_PRIORITY_CODE IS NULL
AND OOL.HEADER_ID=OOH.HEADER_ID
AND OOL.FLOW_STATUS_CODE IN ('AWAITING_SHIPPING','CANCELLED')
AND ROWNUM<=2
-------------------------DO Quantity

SELECT SUM (LINE_QUANTITY) DO_QNT,
            DODL.DO_HDR_ID,
            DODL.ORDER_HEADER_ID,
            DODL.ORDER_LINE_ID
             FROM 
             XXAKG.XXAKG_DEL_ORD_DO_LINES DODL,
             APPS.XXAKG_DEL_ORD_HDR DOH
            WHERE DODL.DO_HDR_ID = DOH.DO_HDR_ID
--            AND DOH.DO_NUMBER='DO/SCOU/21804'
            GROUP BY DODL.DO_HDR_ID, DODL.ORDER_HEADER_ID, DODL.ORDER_LINE_ID
            
            
SELECT
DO_DETAILS.ORG_ID,
ORDER_DETAILS.ORDER_NUMBER,
ORDER_DETAILS.ORDERED_ITEM,
ORDER_DETAILS.ORDERED_QUANTITY,
ORDER_DETAILS.FLOW_STATUS_CODE,
DO_DETAILS.CUSTOMER_NUMBER,
DO_DETAILS.CUSTOMER_NAME,
DO_DETAILS.DO_NUMBER,
DO_DETAILS.DO_QUANTITY,
DO_DETAILS.DO_STATUS
FROM
(SELECT
OOH.HEADER_ID,
OOL.LINE_ID,
OOL.ORDERED_ITEM,
OOL.ORDERED_ITEM_ID,
OOH.ORDER_NUMBER,
OOL.ORDERED_QUANTITY,
OOL.FLOW_STATUS_CODE
FROM 
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
WHERE 1=1
--AND OOH.ORG_ID=85
--AND OOL.SHIPMENT_PRIORITY_CODE IS NULL
AND OOL.HEADER_ID=OOH.HEADER_ID
--AND OOL.FLOW_STATUS_CODE IN ('AWAITING_SHIPPING') 
) ORDER_DETAILS,
(
SELECT 
DOH.ORG_ID,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DODL.ORDER_NUMBER ORD_NUM,
DOH.DO_NUMBER,
DODL.LINE_QUANTITY DO_QUANTITY,
DODL.DO_HDR_ID,
DODL.ORDER_HEADER_ID,
DODL.ORDER_LINE_ID,
DODL.ORDERED_ITEM_ID,
DOH.DO_STATUS
FROM 
XXAKG.XXAKG_DEL_ORD_DO_LINES DODL,
APPS.XXAKG_DEL_ORD_HDR DOH
WHERE 1=1
--AND DOH.ORG_ID=83
AND DODL.DO_HDR_ID= DOH.DO_HDR_ID
--AND DOH.DO_NUMBER='DO/SCOU/21804'
AND DOH.DO_STATUS='GENERATED'
--AND DOH.DO_DATE between '01-JUN-2017' and '01-OCT-2017'
) DO_DETAILS
WHERE 1=1
--AND DO_DETAILS.ORG_ID=83
AND ORDER_DETAILS.ORDERED_ITEM_ID=DO_DETAILS.ORDERED_ITEM_ID
AND ORDER_DETAILS.HEADER_ID=DO_Details.ORDER_HEADER_ID
AND ORDER_DETAILS.LINE_ID=DO_Details.ORDER_LINE_ID
AND ORDER_DETAILS.ORDER_NUMBER=DO_DETAILS.ORD_NUM
--AND ROWNUM<=2