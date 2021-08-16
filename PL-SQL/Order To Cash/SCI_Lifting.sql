--------------------------------------------SCI Lifting----------------------------------------------------

SELECT 'Delivery Order' Delivery_Mode,
substr(DODL.DO_NUMBER,1,instr(DODL.DO_NUMBER,'/',1,1)-1) "MODE of Delivery",
--MODT.CUSTOMER_NUMBER,
--DODL.DO_NUMBER "DO/TO_NUMBER",
--MOH.MOV_ORDER_NO,
--DODL.ITEM_NUMBER,
--DODL.ITEM_DESCRIPTION,
--MOH.TRANSPORT_MODE,
--MOH.VEHICLE_NO,
SUM(DECODE (DODL.UOM_CODE, 'MTN', DODL.LINE_QUANTITY*20,
                                        'BAG', DODL.LINE_QUANTITY,
                                0)) "QUANTITY"
--MODT.*
FROM
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MOH.ORG_ID=85
and MOH.WAREHOUSE_ORG_CODE='SCI'
AND DODL.WAREHOUSE_ORG_CODE='SCI'
AND DODL.DO_HDR_ID=MODT.DO_HDR_ID
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DODL.DO_NUMBER=MODT.DO_NUMBER
AND MODT.TRUCK_LOADING_FLAG='Y'
--AND MODT.CUSTOMER_NUMBER='186151'--'25975'
--AND MOH.MOV_ORDER_NO=:P_MOV_ORDER_NO
--AND TRUNC(MODT.TRUCK_LOADING_DATE) BETWEEN NVL(:P_DATE_FROM,TRUNC(MODT.TRUCK_LOADING_DATE)) AND NVL(:P_DATE_TO,TRUNC(MODT.TRUCK_LOADING_DATE))
AND TO_CHAR(MODT.TRUCK_LOADING_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/MAR/18 06:00:00' AND '2018/MAR/18 14:00:00'--HH:MI:SS--12:00:00
GROUP BY
--MODT.CUSTOMER_NUMBER,
--MOH.TRANSPORT_MODE,
substr(DODL.DO_NUMBER,1,instr(DODL.DO_NUMBER,'/',1,1)-1)
--DODL.DO_NUMBER,
--MOH.MOV_ORDER_NO,
--DODL.ITEM_NUMBER,
--DODL.ITEM_DESCRIPTION,
--MOH.VEHICLE_NO,
UNION ALL
SELECT 'Transfer Order' Delivery_Mode,
substr(TDL.TO_NUMBER,1,instr(TDL.TO_NUMBER,'/',1,1)-1) "MODE of Delivery",
--HCA.ACCOUNT_NUMBER CUSTOMER_NUMBER,
--TDL.TO_NUMBER "DO/TO_NUMBER",
--TMH.MOV_ORDER_NO,
--TDL.ITEM_NUMBER,
--TDL.ITEM_DESCRIPTION,
--TMH.TRANSPORT_MODE,
--TMH.VEHICLE_NO,
SUM(DECODE (TDL.UOM_CODE, 'MTN', TDL.QUANTITY*20,
                                        'BAG', TDL.QUANTITY,
                                0)) "QUANTITY"
--,TMH.*
FROM
XXAKG.XXAKG_TO_MO_HDR TMH,
APPS.XXAKG_TO_MO_DTL TMD,
XXAKG.XXAKG_TO_DO_LINES TDL,
APPS.XXAKG_TO_DO_HDR TOH,
APPS.HZ_CUST_ACCOUNTS HCA
WHERE 1=1
AND TMH.ORG_ID=85
AND TMH.FROM_INV='SCI'
AND TDL.FROM_INV='SCI'
--AND TMH.TRANSPORT_MODE='Company Truck'
AND TMD.TO_HDR_ID=TDL.TO_HDR_ID
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
AND TOH.TO_HDR_ID=TDL.TO_HDR_ID
--AND HCA.ACCOUNT_NUMBER='186151'--'25975'
AND HCA.CUST_ACCOUNT_ID=TOH.CUSTOMER_ID
AND TMD.TRUCK_LOADING_FLAG='Y'
--AND TRUNC(TMD.TRUCK_LOADING_DATE) BETWEEN NVL(:P_DATE_FROM,TRUNC(TMD.TRUCK_LOADING_DATE)) AND NVL(:P_DATE_TO,TRUNC(TMD.TRUCK_LOADING_DATE))
AND TO_CHAR(TMD.TRUCK_LOADING_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/MAR/18 06:00:00' AND '2018/MAR/18 14:00:00'
GROUP BY
--TMH.TRANSPORT_MODE,
substr(TDL.TO_NUMBER,1,instr(TDL.TO_NUMBER,'/',1,1)-1)
--HCA.ACCOUNT_NUMBER,
--TDL.TO_NUMBER,
--TMH.MOV_ORDER_NO,
--TDL.ITEM_NUMBER,
--TDL.ITEM_DESCRIPTION,
--TMH.VEHICLE_NO,
