SELECT 
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) QUANTITY,
DOH.MODE_OF_TRANSPORT,
DODL.ITEM_DESCRIPTION
FROM 
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
XXAKG.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_DEL_ORD_HDR DOH
WHERE 1=1
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DOH.DO_NUMBER=DODL.DO_NUMBER
AND DBM.REGION_NAME!='Scrap'
AND DBM.CUSTOMER_NUMBER=DOH.CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
AND DOH.ORG_ID=84
AND DOH.DO_STATUS='GENERATED'
AND EXISTS (SELECT 1 FROM APPS.OE_ORDER_LINES_ALL OOL WHERE OOL.LINE_ID=DODL.ORDER_LINE_ID AND OOL.FLOW_STATUS_CODE='CANCELLED')
AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2017'
AND DOH.DO_DATE<=SYSDATE
GROUP BY 
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
DOH.MODE_OF_TRANSPORT,
DODL.ITEM_DESCRIPTION