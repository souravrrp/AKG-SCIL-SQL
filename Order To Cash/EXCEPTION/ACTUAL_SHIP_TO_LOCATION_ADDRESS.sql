SELECT
DOH.CUSTOMER_NUMBER "Customer ID",
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DOH.DO_NUMBER,
MOH.MOV_ORDER_NO,
--MOH.VEHICLE_NO,
--MODT.VAT_CHALLAN_NO,
SUM(NVL (DODL.LINE_QUANTITY, 0)) "Quantity(BAG/MTN)",
TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE) SHIPMENT_DATE,
OOL.UNIT_SELLING_PRICE "Rate",
DODL.ITEM_DESCRIPTION "Item Name",
ACSV.LOCATION_ADDRESS "Delivery Location",
DODL.ACTUAL_RETAILER_SHIP_TO "ACTUALLY SHIP_TO_LOCATION"
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
APPS.XXAKG_MOV_ORD_DTL MODT,
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
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND DOH.DO_HDR_ID=MODT.DO_HDR_ID
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
--AND OOL.ACTUAL_SHIPMENT_DATE>='01-NOV-2017'
--and TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'MON-RR')='NOV-17' 
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
--AND DOH.CUSTOMER_NUMBER IN ('186111','186865','187387','187661','187591','187532','186699','186216','185815')
--AND DOH.CUSTOMER_NUMBER=:P_CUSTOMER_NUMBER
AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND MODT.VAT_CHALLAN_NO=:P_VAT_CHALLAN_NO
--and DBM.REGION_NAME IN ('Corporate North','Corporate South','Institutional','MES')
GROUP BY
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
DOH.DO_NUMBER,
MOH.MOV_ORDER_NO,
--MOH.VEHICLE_NO,
--MODT.VAT_CHALLAN_NO,
TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE),
OOL.UNIT_SELLING_PRICE,
DODL.ITEM_DESCRIPTION,
ACSV.LOCATION_ADDRESS,
DODL.ACTUAL_RETAILER_SHIP_TO
ORDER BY DODL.ITEM_DESCRIPTION ASC