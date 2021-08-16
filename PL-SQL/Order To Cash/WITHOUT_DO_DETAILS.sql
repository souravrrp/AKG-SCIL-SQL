SELECT 
MOWD.MOV_ORD_HDR_ID,
MODT.CUSTOMER_NUMBER,
MOH.MOV_ORDER_NO,
MODT.DO_NUMBER,
DODL.LINE_QUANTITY DO_QUANTITY,
MOH.VEHICLE_NO,
MOWD.ITEM_CODE,
MOWD.UOM_CODE,
MOWD.QUANTITY,
MOWD.LOAD_WITHOUT_DO_START,
MOWD.LOAD_WITHOUT_DO_END,
TO_CHAR(MOWD.CREATION_DATE, 'DD/MM/YYYY') WITHOUT_DO_DATE 
FROM
XXAKG.XXAKG_MOV_ORD_WO_DO MOWD
,APPS.XXAKG_MOV_ORD_HDR MOH
,XXAKG.XXAKG_MOV_ORD_DTL MODT
,XXAKG.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND MOH.MOV_ORD_HDR_ID=MOWD.MOV_ORD_HDR_ID
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND MODT.DO_HDR_ID=DODL.DO_HDR_ID
--AND MOH.MOV_ORDER_NO='MO/SCOU/937096'
--AND MOH.VEHICLE_NO='D.M.AU-11-4260'
ORDER BY MOWD.CREATION_DATE DESC
