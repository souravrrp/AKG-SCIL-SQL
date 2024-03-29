SELECT 
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) QUANTITY,
MOH.MOV_ORDER_NO,
DODL.WAREHOUSE_ORG_CODE,
DOH.MODE_OF_TRANSPORT,
MOH.TRANSPORTER_NAME,
DODL.ITEM_DESCRIPTION
,DOH.DO_STATUS
,TO_CHAR (DOH.DO_DATE, 'DD-MON-YYYY') DO_DATE
FROM 
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT,
XXAKG.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_DEL_ORD_HDR DOH
WHERE 1=1
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND DOH.DO_NUMBER=DODL.DO_NUMBER
AND DBM.REGION_NAME!='Scrap'
AND DBM.CUSTOMER_NUMBER=DOH.CUSTOMER_NUMBER
--AND DOH.DO_NUMBER=:P_DO_NUMBER
AND DOH.ORG_ID=85
AND DOH.ORG_ID=MOH.ORG_ID
AND DOH.DO_STATUS='GENERATED'
AND MOH.MOV_ORDER_STATUS='GENERATED'
AND NOT EXISTS (SELECT 1 FROM APPS.OE_ORDER_LINES_ALL OOL WHERE OOL.HEADER_ID=DODL.ORDER_HEADER_ID AND OOL.INVENTORY_ITEM_ID=DODL.ORDERED_ITEM_ID AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING' AND OOL.ORDER_QUANTITY_UOM IN ('BAG','MTN'))
--AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2017'
AND DOH.DO_DATE<='31-AUG-2019'
GROUP BY 
DBM.REGION_NAME,
DBM.CUSTOMER_NUMBER,
DBM.CUSTOMER_NAME,
DOH.DO_NUMBER,
MOH.MOV_ORDER_NO,
DODL.WAREHOUSE_ORG_CODE,
DOH.MODE_OF_TRANSPORT,
MOH.TRANSPORTER_NAME,
DODL.ITEM_DESCRIPTION
,DOH.DO_DATE
,DOH.DO_STATUS;

-----------------------------GENERTED DO----------------------------------------

SELECT
DBM.REGION_NAME,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DOH.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) QUANTITY,
DODL.WAREHOUSE_ORG_CODE,
DOH.MODE_OF_TRANSPORT,
DODL.ITEM_DESCRIPTION
,DOH.DO_STATUS
,TO_CHAR (DOH.DO_DATE, 'DD-MON-YYYY') DO_DATE
FROM
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND DBM.REGION_NAME!='Scrap'
AND DBM.CUSTOMER_NUMBER=DOH.CUSTOMER_NUMBER
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
--AND DODL.ORDERED_ITEM_ID='206571'
AND DODL.UOM_CODE IN ('BAG','MTN')
--AND substr(DODL.ITEM_NUMBER,0,3)='TLH'
--AND DODL.ITEM_NUMBER='MPNA.ORCW.0001'
--AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND DODL.ORDER_NUMBER IN ('1417741')
--AND DOH.DO_NUMBER IN ('DO/SCOU/1400335')
AND DOH.DO_STATUS IN ('GENERATED')--CONFIRMED
AND DOH.DO_DATE<='31-MAY-2019'
--AND TO_CHAR(DOH.DO_DATE,'DD-MON-RR')='03-APR-18'
--AND DOH.DO_DATE BETWEEN '01-JAN-2010' and '30-APR-2018'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'DEC-17'
--AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2018'
--AND DOH.CUSTOMER_NUMBER='190036'
AND DOH.ORG_ID=85
--AND DODL.WAREHOUSE_ORG_CODE='G31'
GROUP BY 
DBM.REGION_NAME,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DOH.DO_NUMBER,
DODL.WAREHOUSE_ORG_CODE,
DOH.MODE_OF_TRANSPORT,
DODL.ITEM_DESCRIPTION
,DOH.DO_DATE
,DOH.DO_STATUS;