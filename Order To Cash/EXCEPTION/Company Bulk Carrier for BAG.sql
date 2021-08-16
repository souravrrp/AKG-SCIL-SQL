SELECT
DOH.ORG_ID,
DOH.OPERATING_UNIT,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DOH.MODE_OF_TRANSPORT,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,DODL.ITEM_NUMBER, 
DODL.ITEM_DESCRIPTION,
SUM(LINE_QUANTITY) QUANTITY,
DODL.WAREHOUSE_ORG_CODE,
TO_CHAR(DOH.DO_DATE) DELIVERY_DATE
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
--AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND DODL.ORDER_NUMBER=:P_ORDER_NUMBER
--AND DOH.DO_STATUS='GENERATED'
AND DOH.DO_DATE>='01-JAN-2018'
--AND MOH.CONFIRMED_DATE BETWEEN '15-OCT-2017' and '16-NOV-2017'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'DEC-17'
AND DOH.ORG_ID=85
AND DODL.UOM_CODE='BAG'
AND DOH.MODE_OF_TRANSPORT='Company Bulk Carrier'
GROUP BY
DOH.ORG_ID,
DOH.OPERATING_UNIT,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DOH.MODE_OF_TRANSPORT,
DODL.ORDER_NUMBER,
DODL.DO_NUMBER,DODL.ITEM_NUMBER, 
DODL.ITEM_DESCRIPTION,
DODL.WAREHOUSE_ORG_CODE,
DOH.DO_DATE
ORDER BY DOH.DO_DATE DESC