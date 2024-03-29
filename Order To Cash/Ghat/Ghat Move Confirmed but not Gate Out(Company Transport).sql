SELECT
MOH.VEHICLE_NO,
MOH.MOV_ORDER_NO,
MOH.MOV_ORDER_STATUS,
MOH.WAREHOUSE_ORG_CODE,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.TRANSPORTER_NAME,
MOH.INITIAL_GATE_IN,
MOH.GATE_OUT,
MOH.GATE_IN,
MOH.READY_FOR_INVOICE,
MOH.GATE_PASS_NO,
MOH.EMPTY_TRUCK_WT,
MOH.SCALE_IN_WT,
MOH.HIRE_RATE_AP,
TO_CHAR(MOH.CONFIRMED_DATE) CONFIRMED_DATE 
FROM
APPS.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND MOH.CONFIRMED_DATE<= '31-DEC-2018'
AND TRANSPORT_MODE='Company Truck'
AND MOH.GATE_OUT IS NULL
--AND MOH.GATE_IN IS NULL
AND MOH.VEHICLE_NO!='SCIL-SCM-0001'
AND MOH.ORG_ID=85
AND MOH.WAREHOUSE_ORG_CODE!='SCI'
AND MOH.MOV_ORDER_STATUS='CONFIRMED'
ORDER BY MOH.CONFIRMED_DATE DESC