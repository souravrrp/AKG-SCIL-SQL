SELECT
MOH.*
--MODT.*
--MOH.HIRE_RATE_AP
--,MOH.KM_PER_LITRE
--,MOH.OIL_REFIL_QTY_OCTANE
FROM
APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MOH.ORG_ID=85
--AND MOH.WAREHOUSE_ORG_CODE='SCI'
--AND MOH.WAREHOUSE_ORG_ID=101
AND MOH.MOV_ORD_HDR_ID=MODT.MOV_ORD_HDR_ID
--AND MOH.VEHICLE_NO=:P_VEHICLE_NO--'D.M.U-11-0949'--'D.M.U-11-1118'--
--AND MOH.MOV_ORDER_STATUS='CONFIRMED'--'GENERATED'
--AND MOH.INITIAL_GATE_IN='Y'
--AND MOH.FINAL_DESTINATION IN ('For Loading','AKCL Workshop')
AND MOH.TRANSPORT_MODE='Company Truck'
--AND MOH.TRANSPORTER_NAME='AKCL'
AND MOH.MOV_ORDER_TYPE='RELATED'
--AND MOH.GATE_OUT IS NULL
--AND MOH.GATE_IN IS NULL
--AND MOH.READY_FOR_INVOICE='N'
--AND MOH.GATE_PASS_NO=89789789789
--AND MOH.GATE_PASS_DATE IS NOT NULL
--AND MOH.EMPTY_TRUCK_WT IS NULL
--AND MOH.EMPTY_TRUCK_WT_DATE IS NULL
--AND MOH.SCALE_IN_WT IS NULL
--AND AND MOH.FULL_TRUCK_WT_DATE IS NULL
--AND MOH.INITIAL_GATE_IN_DATE IS NOT NULL
--AND MOH.GATE_OUT_DATE IS NOT NULL
--AND MOH.GATE_IN_DATE IS NOT NULL
--AND MOH.MOV_ORDER_DATE BETWEEN '01-OCT-2017' AND '28-OCT-2017'
--AND MOH.CONFIRMED_DATE BETWEEN '01-OCT-2017' AND '28-OCT-2017'
--AND MOH.AP_FLAG IS NULL
--AND MOH.HIRE_RATE_AP IS NULL
---------------------------------------------------------------------------------------------------
--AND MODT.CUSTOMER_NUMBER=35578
--AND MODT.DO_NUMBER=:P_DO_NUMBER
--AND MODT.CONFIRM_FLAG='Y'
--AND MODT.CONFIRM_DATE IS NULL
--AND MODT.TRANSFER_LOADING_FLAG='Y'
--AND MODT.TRANSFER_LOADING_DATE IS NOT NULL
--AND MODT.TRUCK_LOADING_FLAG='Y'
--AND MODT.TRUCK_LOADING_DATE IS NOT NULL
--AND MODT.VAT_IN_FLAG='Y'
--AND MODT.VAT_IN_DATE IS NOT NULL
--AND MODT.VAT_RECEIVED_FLAG='Y'
--AND MODT.VAT_RECEIB=VED_DATE IS NOT NULL
--AND MODT.CHALLANED_FLAG='Y'
--AND MODT.CHALLANED_DATE IS NOT  NULL
--AND MODT.VAT_CHALLAN_NO=274735
--AND MODT.VAT_CHALLAN_DATE IS NOT NULL
--AND MODT.CREATION_DATE IS NULL --BETWEEN '01-OCT-2017' AND '28-OCT-2017'
ORDER BY MOV_ORDER_DATE DESC