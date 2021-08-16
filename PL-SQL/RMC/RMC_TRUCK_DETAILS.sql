SELECT
MOH.VEHICLE_NO,
MOH.MOV_ORDER_NO,
MOH.MOV_ORDER_STATUS,
MOH.WAREHOUSE_ORG_CODE,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.INITIAL_GATE_IN,
MOH.GATE_OUT,
MOH.GATE_IN,
MOH.GATE_PASS_NO
--TO_CHAR(MOH.CONFIRMED_DATE) CONFIRMED_DATE 
FROM
APPS.XXAKG_MOV_ORD_HDR MOH
,APPS.PQP_VEHICLE_REPOSITORY_F VR
WHERE 1=1
AND VR.VRE_ATTRIBUTE2=MOH.ORG_ID
AND VR.VRE_ATTRIBUTE3='RMC'
AND VR.VEHICLE_STATUS='A'
--AND EFFECTIVE_END_DATE>=SYSDATE
AND MOH.VEHICLE_NO=VR.REGISTRATION_NUMBER
--AND MOH.CONFIRMED_DATE>= '19-NOV-2017'
--AND MOH.MOV_ORDER_STATUS='CONFIRMED'
--AND MOH.TRANSPORT_MODE='Company Truck'
AND MOH.GATE_IN IS NULL
--AND MOH.GATE_OUT IS NULL
--AND MOH.VEHICLE_NO=:P_VEHICLE_NO-- IS NOT NULL
AND MOH.ORG_ID=84
--AND GATE_PASS_NO IS NULL
ORDER BY MOH.CONFIRMED_DATE DESC


---------------------------RMC Vehicle------------------------------------------------------
SELECT
VR.REGISTRATION_NUMBER
FROM
APPS.PQP_VEHICLE_REPOSITORY_F VR
WHERE 1=1
AND VR.VRE_ATTRIBUTE3='RMC'
AND VR.VEHICLE_STATUS='A'
AND EFFECTIVE_END_DATE>=SYSDATE