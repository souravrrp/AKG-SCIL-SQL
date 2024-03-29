SELECT 
DBM.REGION_NAME REGION,
TO_CHAR(FM.MO_DATE) MOVE_ORDER_DATE,
DOH.CUSTOMER_NAME,
DOH.CUSTOMER_NUMBER CUSTOMER_ID,
DOH.DO_NUMBER DO_NO,
MOH.MOV_ORDER_NO MOV_NO,
MOH.VEHICLE_NO Truck_No,
FM.MO_QUANTITY QTY,
FM.NUMBER_OF_POINT No_of_Delivery_Point,
FM.ACCTUAL_KM "Total KM"
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT,
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM
,APPS.XXAKG_FUEL_MAINTANANCE FM
WHERE 1=1
AND MODT.DO_HDR_ID=DOH.DO_HDR_ID
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND DOH.CUSTOMER_NUMBER=MODT.CUSTOMER_NUMBER
AND DOH.ORG_ID=DBM.ORG_ID
AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
AND MOH.MOV_ORDER_NO=FM.MOVE_ORDER_NO
AND MOH.VEHICLE_NO=FM.VEHICLE_NUMBER
--AND FM.NUMBER_OF_POINT IS NOT NULL
AND TO_CHAR (FM.MO_DATE, 'MON-RR') = 'NOV-17'
--AND DOH.DO_NUMBER=:P_DO_NUMBER
--AND MOH.MOV_ORDER_NO=:P_MOV_ORDER_NO




SELECT *
--MOVE_ORDER_NO,
--NUMBER_OF_POINT,
--ACCTUAL_KM,
--MO_QUANTITY
FROM APPS.XXAKG_FUEL_MAINTANANCE
WHERE 1=1
--AND MOVE_ORDER_NO='MO/SCOU/987114'
--AND ROWNUM<=3
--ORDER BY MO_DATE DESC




