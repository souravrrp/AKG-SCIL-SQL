------------------------------Order Details---------------------------------------------------
SELECT 
OOH.ORG_ID,
APPS.XXAKG_COM_PKG.GET_ORGANIZATION_NAME (OOH.ORG_ID) OPERATING_UNIT,
APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOH.SOLD_TO_ORG_ID) REGION, 
--OOH.SOLD_TO_ORG_ID CUSTOMER_ID,
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (OOH.SOLD_TO_ORG_ID) CUSTOMER_NUMBER, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_FROM_ID (OOH.SOLD_TO_ORG_ID) CUSTOMER_NAME,
OOH.ORDER_NUMBER,
--OOH.ORDER_TYPE_ID,
OOH.ORDERED_DATE,
OOH.BOOKED_DATE,
OOH.HEADER_ID,
OOL.LINE_ID,
OOL.INVENTORY_ITEM_ID,
OOL.ORDERED_ITEM ITEM_CODE,
(SELECT DESCRIPTION FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=OOL.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID= OOL.SHIP_FROM_ORG_ID) ITEM_DESCRIPTION,
OOL.ORDER_QUANTITY_UOM UOM_CODE,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
OOH.FLOW_STATUS_CODE ORDER_HEADER_STATUS,
OOL.FLOW_STATUS_CODE ORDER_LINE_STATUS,
OOL.ORDERED_QUANTITY,
(CASE 
WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (OOL.ORDERED_QUANTITY*1000)/50
ELSE DECODE (ORDER_QUANTITY_UOM,'MTN', NVL (ORDERED_QUANTITY, 0) * 20,NVL (ORDERED_QUANTITY, 0))
END) CONVERT_BAG_QTY,
OOL.SHIPPED_QUANTITY,
(CASE 
WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (OOL.SHIPPED_QUANTITY*1000)/50
ELSE DECODE (ORDER_QUANTITY_UOM, 'MTN', NVL (OOL.SHIPPED_QUANTITY, 0) * 20, NVL (OOL.SHIPPED_QUANTITY, 0))
END) CONVERT_SHIPPED_BAG_QTY,
OOL.INVOICED_QUANTITY,
OOL.CANCELLED_QUANTITY,
OOL.ACTUAL_SHIPMENT_DATE,
OOL.UNIT_SELLING_PRICE,
OOL.PRICING_DATE,
OOL.PRICE_LIST_ID,
OOL.ATTRIBUTE10 PRICE_LOCATION,
OOL.ATTRIBUTE11 TRANSPORT_MODE,
OOL.ATTRIBUTE13 DELIVERY_MODE,
OOL.SHIP_TO_ORG_ID,
APPS.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION (OOL.SHIP_TO_ORG_ID) DELIVERY_SITE,
OOL.SHIP_FROM_ORG_ID WAREHOUSE_ORG_ID,
APPS.XXAKG_COM_PKG.GET_ORGANIZATION_NAME (OOL.SHIP_FROM_ORG_ID) WAREHOUSE_ORG_NAME
,APPS.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID(OOL.CREATED_BY)||' ('||APPS.XXAKG_COM_PKG.GET_USER_NAME(OOL.CREATED_BY)||')' LAST_UPDATED_BY
--,(OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY) AMOUNT
--,OOH.*
--,OOL.*
--,CUST.*
FROM
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
--,APPS.XXAKG_REGION_BLOCK_CELL_V CUST
WHERE 1=1 
AND ((:P_ORG_ID IS NULL AND OOH.ORG_ID IN (83,84,85,605)) OR (OOH.ORG_ID=:P_ORG_ID))
--AND CUST.CUSTOMER_ID=OOL.SOLD_TO_ORG_ID
--AND CUST.SHIP_SITE_LOCATION_ID=OOL.SHIP_TO_ORG_ID
--AND CUST.CUSTOMER_NUMBER='188686'
--AND APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (OOH.SOLD_TO_ORG_ID)= :P_CUSTOMER_NUMBER
--AND APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOH.SOLD_TO_ORG_ID) = :P_REGION_NAME
AND OOH.HEADER_ID=OOL.HEADER_ID
AND     (:P_ORDER_NUMBER IS NULL OR (OOH.ORDER_NUMBER = :P_ORDER_NUMBER))
AND     (:P_DO_NUMBER IS NULL OR (OOL.SHIPMENT_PRIORITY_CODE = :P_DO_NUMBER))
AND EXISTS(SELECT 1 FROM APPS.XXAKG_AR_CUSTOMER_SITE_V A, APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM WHERE A.CUSTOMER_ID=DBM.CUSTOMER_ID(+) AND A.ORG_ID=DBM.ORG_ID AND A.CUSTOMER_ID=OOL.SOLD_TO_ORG_ID AND A.SHIP_TO_ORG_ID=OOL.SHIP_TO_ORG_ID
            AND     (:P_CUSTOMER_NUMBER IS NULL OR (A.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
            --AND CUSTOMER_NUMBER IN ('187056')
            AND     (:P_CUST_NAME IS NULL OR (UPPER(A.CUSTOMER_NAME) LIKE UPPER('%'||:P_CUST_NAME||'%') ))
            --AND DBM.REGION_NAME IN ('Gazipur','Dhaka South','Mymensingh','Rajshahi','Sylhet','Rangpur','Prime Seller','Comilla','Faridpur','Dhaka North','Narayangonj','Khulna','Barisal','Tangail','Bogra','Noakhali','Chittagong')
            --DBM.REGION_NAME IN ('Corporate North','Corporate South','Institutional','MES')
            --DBM.REGION_NAME IN ('Export','Inter Group','Held','Scrap')
            --AND SITE_USE_CODE = 'BILL_TO'
            --AND SITE_USE_CODE = 'SHIP_TO' 
            --AND STATUS = 'A'
            --AND A.PARTY_SITE_NUMBER='47540'
            )
--AND OOH.ORDER_NUMBER IN ('1759890')
--AND OOL.ORDER_QUANTITY_UOM='MTN'
--AND OOL.ORDERED_ITEM='SCRP.CAN0.0001'
--AND OOL.INVENTORY_ITEM_ID='206571'
--AND OOH.FLOW_STATUS_CODE='CLOSED'--'BOOKED'
--AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING'-- NOT IN ('CLOSED','SHIPPED','CANCELLED','ENTERED','AWAITING_SHIPPING','AWAITING_RETURN_DISPOSITION','AWAITING_RETURN','BOOKED','FULFILLED','RETURNED')
--AND OOL.SHIPMENT_PRIORITY_CODE IN ('DO/SCOU/1514922')
--AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--AND  TRUNC(BOOKED_DATE) > '20-Oct-2019' 
--AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'APR-18'
--AND TO_CHAR (OOH.ORDERED_DATE, 'MON-RR') = 'APR-18'
--AND TO_CHAR (OOH.ORDERED_DATE, 'RRRR') = '2018'
--AND TO_CHAR (OOH.ORDERED_DATE, 'DD-MON-RR') = '17-JUN-19'
--AND ORDER_TYPE_ID=1101
--AND OOH.SHIP_FROM_ORG_ID=1346
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND MSI.SEGMENT1='CMNT')
ORDER BY OOH.ORDERED_DATE DESC



------------------------------DO Details---------------------------------------------------
SELECT
DOH.DO_NUMBER
,DOH.CUSTOMER_NUMBER
,DOH.CUSTOMER_NAME
,DOH.DO_STATUS
,DODL.ORDER_NUMBER
,DODL.ITEM_NUMBER
,DOH.FINAL_DESTINATION
,DODL.WAREHOUSE_ORG_CODE
--,DOH.*
,DODL.*
FROM
APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND ((:P_ORG_ID IS NULL AND DOH.ORG_ID IN (83,84,85,605))  OR (DOH.ORG_ID=:P_ORG_ID))
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
--AND DODL.ORDERED_ITEM_ID='206571'
--AND substr(DODL.ITEM_NUMBER,0,3)='TLH'
--AND DODL.ITEM_NUMBER IN ('MPNA.ORCW.0001')
--AND DODL.ORDER_NUMBER IN ('1759890')
AND     (:P_ORDER_NUMBER IS NULL OR (DODL.ORDER_NUMBER = :P_ORDER_NUMBER))
AND     (:P_DO_NUMBER IS NULL OR (DOH.DO_NUMBER = :P_DO_NUMBER))
AND     (:P_CUSTOMER_NUMBER IS NULL OR (DOH.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
AND     (:P_ORG_CODE IS NULL OR (DODL.WAREHOUSE_ORG_CODE = :P_ORG_CODE))
--AND DOH.DO_NUMBER IN ('DO/SCOU/1400335')
--AND DOH.DO_STATUS IN ('GENERATED')--CONFIRMED
--AND TRUNC(DOH.DO_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--AND TO_CHAR(DOH.DO_DATE,'DD-MON-RR')='03-APR-18'
--AND DOH.DO_DATE BETWEEN '01-JAN-2010' and '30-APR-2018'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'DEC-17'
--AND TO_CHAR (DOH.DO_DATE, 'RRRR') = '2018'
--AND DOH.CUSTOMER_NUMBER IN ('190036')
--AND VEHICLE_LOAD_CAPACITY IS NOT NULL
--AND TRANSPORTER_NAME='M/S SCR Transport ~ SUP-001534.'
--AND DODL.WAREHOUSE_ORG_CODE IN ('SCI')
--AND NOT EXISTS (SELECT 1 FROM XXAKG.XXAKG_MOV_ORD_DTL MODT WHERE DOH.DO_HDR_ID=MODT.DO_HDR_ID)
ORDER BY DOH.DO_DATE DESC


------------------------------Move Details---------------------------------------------------
SELECT
MOH.MOV_ORDER_NO
,MOH.WAREHOUSE_ORG_CODE
,MOH.TRANSPORT_MODE
,MODT.DO_NUMBER
,MODT.CUSTOMER_NUMBER
--,(SELECT DOH.DO_STATUS FROM APPS.XXAKG_DEL_ORD_HDR DOH WHERE 1=1 AND DOH.DO_NUMBER=MODT.DO_NUMBER) DO_STATUS
--,(SELECT OL.FLOW_STATUS_CODE FROM APPS.OE_ORDER_LINES_ALL OL WHERE 1=1 AND OL.SHIPMENT_PRIORITY_CODE=MODT.DO_NUMBER) DELIVERY_STATUS
,MOH.VEHICLE_NO
,MOH.*
--,MODT.*
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
,XXAKG.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID(+)
--AND MOH.MOV_ORD_HDR_ID='2248926'
AND ((:P_ORG_ID IS NULL AND MOH.ORG_ID IN (83,84,85,605))  OR (MOH.ORG_ID=:P_ORG_ID))
AND     (:P_MOVE_ORDER_NO IS NULL OR (MOH.MOV_ORDER_NO = :P_MOVE_ORDER_NO))
AND     (:P_VEHICLE_NO IS NULL OR (MOH.VEHICLE_NO = :P_VEHICLE_NO))
AND     (:P_DO_NUMBER IS NULL OR (MODT.DO_NUMBER = :P_DO_NUMBER))
AND     (:P_CUSTOMER_NUMBER IS NULL OR (MODT.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
AND     (:P_ORG_CODE IS NULL OR (MOH.WAREHOUSE_ORG_CODE = :P_ORG_CODE))
AND TRUNC(MOH.MOV_ORDER_DATE) BETWEEN NVL(:P_MOVE_DATE_FROM,TRUNC(MOH.MOV_ORDER_DATE)) AND NVL(:P_MOVE_DATE_TO,TRUNC(MOH.MOV_ORDER_DATE))
--AND TRUNC(MOH.GATE_OUT_DATE) BETWEEN NVL(:P_GATE_OUT_DATE_FROM,TRUNC(MOH.GATE_OUT_DATE)) AND NVL(:P_GATE_OUT_DATE_TO,TRUNC(MOH.GATE_OUT_DATE))
--AND WAREHOUSE_ORG_CODE='SCI'
--AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier','Company Truck')
--AND MOH.VEHICLE_NO LIKE '%2369%' --IN ('D.M.U-12-1695')
--AND MOH.MOV_ORDER_NO IN ('MO/SCOU/1220918')
--AND MOV_ORDER_STATUS IN ('CONFIRMED')--GENERATED
--AND TO_CHAR(MOH.MOV_ORDER_DATE,'DD-MON-RR')='31-DEC-18'
--AND TO_CHAR(MOH.MOV_ORDER_DATE,'MON-RR')='DEC-18'
--AND TO_CHAR(MOH.MOV_ORDER_DATE,'RRRR')='2018'
--AND DOH.DO_DATE BETWEEN '01-JAN-2010' and '30-APR-2018'
--AND TRUNC(MOH.MOV_ORDER_DATE) BETWEEN '28-NOV-2018' and '29-NOV-2018'
--AND MODT.DO_NUMBER IN ('DO/SCOU/1152730')
--AND MODT.CUSTOMER_NUMBER IN ('20058')
--AND MOH.FINAL_DESTINATION='Norshindi'
--AND MODT.CHALLAN_NO IN ('SCI/154177','SCI/162514','SCI/169562','SCI/166840')
--AND MOH.HIRE_RATE_AP=100
--AND MOH.GATE_PASS_NO='693452'
--AND MODT.VAT_IN_FLAG='Y'
--AND MODT.CHALLANED_FLAG!='Y'
--AND MOH.INITIAL_GATE_IN='Y'
--AND MOH.GATE_OUT IS NULL
--AND MOH.GATE_IN IS NULL
--AND MOH.SCALE_IN_WT!='0'
--AND MOH.EMPTY_TRUCK_WT!='0'
--AND TO_CHAR(MOH.GATE_OUT_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2019/OCT/27 01:00:01' AND '2019/OCT/27 23:59:00'--HH:MI:SS--12:00:00
--AND NOT EXISTS (SELECT 1 FROM APPS.XXAKG_FUEL_MAINTANANCE FU WHERE FU.MOVE_ORDER_NO=MOH.MOV_ORDER_NO)
--AND EXISTS(SELECT 1 FROM APPS.OE_ORDER_LINES_ALL OL WHERE 1=1 AND OL.SHIPMENT_PRIORITY_CODE=MODT.DO_NUMBER AND OL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED'))
ORDER BY MOH.MOV_ORDER_DATE DESC

----------------------------------------Invoice Details---------------------------------------
SELECT
*
FROM
APPS.AP_INVOICES_ALL AIA
WHERE 1=1
--AND AIA.INVOICE_NUM=:P_INVOICE_NUM
AND AIA.INVOICE_NUM IN ('MO/SCOU/870782')


----------------------------------------Delivery Details---------------------------------------
SELECT
*
FROM
APPS.WSH_DELIVERY_DETAILS
WHERE 1=1
--AND DELIVERY_DETAIL_ID='3318308'
--AND RELEASED_STATUS 
--AND SHIPMENT_PRIORITY_CODE=:P_DO_NUMBER
AND SHIPMENT_PRIORITY_CODE='DO/SCOU/1319750'
--AND SOURCE_LINE_ID='10809382'
--AND SOURCE_HEADER_ID='3727754'


SELECT
*
FROM
APPS.WSH_DELIVERABLES_V
WHERE 1=1
--AND DELIVERY_ID='3658810'
--AND RELEASED_STATUS 
--AND SHIPMENT_PRIORITY_CODE=:P_DO_NUMBER
--AND SHIPMENT_PRIORITY_CODE='DO/SCOU/1319750'
AND SOURCE_HEADER_NUMBER='1721678'
--AND SOURCE_LINE_ID='10809382'
--AND SOURCE_HEADER_ID='3727754'


------------------------------------------------------------------------------------------------


SELECT
*
FROM
APPS.WSH_PICKING_BATCHES
WHERE 1=1
AND BATCH_ID='12715272'




----------------------------------------Order_DO_Move---------------------------------------
SELECT
OOH.ORDER_NUMBER,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER
--,OOH.*
,OOL.*
--,DOH.*
--,DODL.*
--,MOH.*
--,MODT.*
--,WPB.*
FROM
APPS.AR_CUSTOMERS AC
,APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM
,APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL OOL,
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT
,APPS.WSH_DELIVERABLES_V WSHD
,APPS.WSH_PICKING_BATCHES WPB
,APPS.MTL_TXN_REQUEST_HEADERS MTRH
,APPS.MTL_TXN_REQUEST_LINES MTRL
,INV.MTL_MATERIAL_TRANSACTIONS MMT
,INV.MTL_TRANSACTION_TYPES MTT
,APPS.RA_CUSTOMER_TRX_ALL CT
,APPS.RA_CUSTOMER_TRX_LINES_ALL CL
,APPS.RA_CUST_TRX_LINE_GL_DIST_ALL DST
,APPS.RA_CUST_TRX_TYPES_ALL TT
WHERE 1=1
AND AC.CUSTOMER_ID=OOL.SOLD_TO_ORG_ID
AND AC.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
AND OOL.HEADER_ID=OOH.HEADER_ID
AND OOL.SHIPMENT_PRIORITY_CODE=DOH.DO_NUMBER
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND DOH.CUSTOMER_NUMBER=MODT.CUSTOMER_NUMBER
AND OOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
AND OOL.LINE_ID = WSHD.SOURCE_LINE_ID
AND WSHD.BATCH_ID=WPB.BATCH_ID
--AND WPB.BATCH_ID=MTRH.HEADER_ID
AND WPB.NAME=MTRH.REQUEST_NUMBER
AND MTRH.HEADER_ID=MTRL.HEADER_ID
AND MTRH.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND MMT.TRANSACTION_SOURCE_ID=MTRL.TXN_SOURCE_ID
AND MTT.TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID
AND MTT.TRANSACTION_TYPE_NAME IN ('Sales order issue')
--AND TO_CHAR(OOH.ORDER_NUMBER)=CT.INTERFACE_HEADER_ATTRIBUTE1
AND TO_CHAR(OOL.HEADER_ID)=TO_CHAR(CT.INTERFACE_HEADER_ATTRIBUTE3)
AND TO_CHAR(OOL.LINE_ID)=TO_CHAR(CT.INTERFACE_HEADER_ATTRIBUTE6)
AND CT.CUSTOMER_TRX_ID = CL.CUSTOMER_TRX_ID
AND CT.CUSTOMER_TRX_ID = DST.CUSTOMER_TRX_ID
AND DST.CUSTOMER_TRX_LINE_ID = CL.CUSTOMER_TRX_LINE_ID
AND CT.CUST_TRX_TYPE_ID = TT.CUST_TRX_TYPE_ID
--AND MMT.TRANSACTION_SOURCE_ID=MTRH.HEADER_ID
--AND MTRL.LINE_ID=MMT.MOVE_ORDER_LINE_ID
--AND DOH.CUSTOMER_NUMBER='20057'
--AND MODT.VAT_CHALLAN_NO=:P_VAT_CHALLAN_NO
--AND OOH.ORDER_NUMBER='1609136'
--AND DOH.DO_NUMBER=:P_DO_NUMBER
AND DOH.DO_NUMBER='DO/SCOU/1158133'
--AND DOH.DO_STATUS='GENERATED'
--AND DOH.DO_STATUS='CONFIRMED'
--AND MOH.MOV_ORDER_NO=:P_MOV_ORDER_NO
--AND MOH.MOV_ORDER_NO='MO/SCOU/036734'
--AND MOV_ORDER_STATUS='GENERATED'
--AND MOV_ORDER_STATUS='CONFIRMED'
--AND DODL.ITEM_NUMBER LIKE '%SCRP.%'
--AND DODL.WAREHOUSE_ORG_ID=1346
--AND OOH.ORDER_TYPE_ID=1101
--AND OOH.SHIP_FROM_ORG_ID=805



----------------------------------------Look_UP_Values-------------------------------------
SELECT
*
FROM
APPS.FND_LOOKUP_VALUES
WHERE 1=1
--AND DESCRIPTION=:P_DESCRIPTION
--AND LOOKUP_CODE=:P_LOOKUP_CODE
--AND LOOKUP_CODE='DO/SCOU/1040299'
--AND DESCRIPTION='MO/SCOU/1032920'



------------------------------------------------------------------------------------------------

 SELECT
    DOH.CUSTOMER_NUMBER,
    DOH.CUSTOMER_NAME,
    OOH.ORDER_NUMBER,
    TO_CHAR(OOH.ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS') ORDERED_DATE,
    OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
    TO_CHAR(DOH.DO_DATE,'DD-MON-YYYY HH24:MI:SS') DO_DATE,
    OOD.ORGANIZATION_NAME,
    OOD.ORGANIZATION_CODE,
    MOH.MOV_ORDER_NO,
    MOH.TRANSPORT_MODE,
    MOH.FINAL_DESTINATION,
    MOH.VEHICLE_NO,
    OOL.ORDERED_ITEM,
    WSHD.ITEM_DESCRIPTION,
    NVL (OOL.ORDERED_QUANTITY, 0) DO_QUANTITY,
    (CASE 
        WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (OOL.ORDERED_QUANTITY*1000)/50
            ELSE DECODE (ORDER_QUANTITY_UOM,'MTN', NVL (ORDERED_QUANTITY, 0) * 20,NVL (ORDERED_QUANTITY, 0))
    END) CONVERT_QTY,
    NVL(WPB.NAME,0) BATCH_NO,
    NVL(TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE),0) INVOICE_DATE,
    NVL(MODT.VAT_CHALLAN_NO,0) VAT_CHALLAN_NO,
    TO_CHAR(MODT.VAT_CHALLAN_DATE) VAT_CHALLAN_DATE,
    OOL.FLOW_STATUS_CODE ORDER_LINE_STATUS,
    WSHD.RELEASED_STATUS_NAME DELIVERY_STATUS,
    DOH.DO_STATUS,
    MOH.MOV_ORDER_STATUS,
    TO_CHAR(MOH.MOV_ORDER_DATE,'DD-MON-YYYY HH24:MI:SS') MOVE_ORDER_DATE
    ,TO_CHAR(MOH.CONFIRMED_DATE,'DD-MON-YYYY HH24:MI:SS') CONFIRMED_DATE
    ,MOH.GATE_OUT
    ,MOH.GATE_IN
    ,MOH.READY_FOR_INVOICE
    ,MOH.AP_FLAG
FROM APPS.OE_ORDER_HEADERS_ALL OOH,
    APPS.OE_ORDER_LINES_ALL OOL, 
    APPS.XXAKG_DEL_ORD_HDR DOH,
    APPS.XXAKG_MOV_ORD_DTL MODT,
    APPS.XXAKG_MOV_ORD_HDR MOH,
    APPS.WSH_DELIVERABLES_V WSHD,
    APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
    APPS.WSH_PICKING_BATCHES WPB,
    APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE    1=1
      AND OOH.HEADER_ID=OOL.HEADER_ID
      AND DOH.DO_HDR_ID = MODT.DO_HDR_ID
      AND MOH.MOV_ORD_HDR_ID = MODT.MOV_ORD_HDR_ID
      AND MOH.ORG_ID = DOH.ORG_ID
      AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
      AND MOH.ORG_ID = OOL.ORG_ID
      AND DBM.ORG_ID = OOL.ORG_ID
      AND OOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
      AND OOL.LINE_ID = WSHD.SOURCE_LINE_ID
      AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
      AND WSHD.BATCH_ID=WPB.BATCH_ID(+)
--      AND OOL.ORDERED_ITEM='CMNT.OBAG.0004'
--      AND MODT.VAT_CHALLAN_DATE IS NULL
--      AND MOH.GATE_IN IS NULL
--      AND OOD.ORGANIZATION_CODE !='SCI'
--      AND MOH.TRANSPORT_MODE IN ('Company Truck')
--      AND WSHD.RELEASED_STATUS_NAME='Staged/Pick Confirmed'-- IN ('Ready to Release')
--      AND DBM.REGION_NAME='Scrap'
      AND OOL.SHIP_FROM_ORG_ID=OOD.ORGANIZATION_ID
      AND     (:P_ORG_ID IS NULL OR (DOH.ORG_ID=:P_ORG_ID))
--      AND     (:P_WAREHOUSE IS NULL OR (OOD.ORGANIZATION_CODE = :P_WAREHOUSE))
      AND     (:P_REGION_NAME_EXCLUDE IS NULL OR (DBM.REGION_NAME <> :P_REGION_NAME_EXCLUDE))
--      AND     (:P_CUSTOMER_NUMBER IS NULL OR (DOH.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
--      AND     (:P_ORDER_NUMBER IS NULL OR (OOH.ORDER_NUMBER = :P_ORDER_NUMBER))
--      AND     (:P_STATUS IS NULL OR (OOL.FLOW_STATUS_CODE = :P_STATUS))
--      AND     (:P_DO_NUMBER IS NULL OR (DOH.DO_NUMBER = :P_DO_NUMBER))
--      AND     (:P_VEHICLE_NUMBER IS NULL OR (MOH.VEHICLE_NO = :P_VEHICLE_NUMBER))
--      AND     (:P_MOV_ORDER_NO IS NULL OR (MOH.MOV_ORDER_NO = :P_MOV_ORDER_NO))
--      AND TRUNC(OOH.ORDERED_DATE) BETWEEN NVL(:P_ORDERED_DATE_FROM,TRUNC(OOH.ORDERED_DATE)) AND NVL(:P_ORDERED_DATE_TO,TRUNC(OOH.ORDERED_DATE))
--      AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE) BETWEEN NVL(:P_INVOICE_DATE_FROM,TRUNC(OOL.ACTUAL_SHIPMENT_DATE)) AND NVL(:P_INVOICE_DATE_TO,TRUNC(OOL.ACTUAL_SHIPMENT_DATE))
--      AND TRUNC(DOH.DO_DATE) BETWEEN NVL(:P_DATE_FROM,TRUNC(DOH.DO_DATE)) AND NVL(:P_DATE_TO,TRUNC(DOH.DO_DATE))
--      AND TRUNC(MOH.MOV_ORDER_DATE) BETWEEN NVL(:P_MOVE_DATE_FROM,TRUNC(MOH.MOV_ORDER_DATE)) AND NVL(:P_MOVE_DATE_TO,TRUNC(MOH.MOV_ORDER_DATE))
--      AND TRUNC(MOH.CONFIRMED_DATE) BETWEEN NVL(:P_CONFIRMED_DATE_FROM,TRUNC(MOH.CONFIRMED_DATE)) AND NVL(:P_CONFIRMED_DATE_TO,TRUNC(MOH.CONFIRMED_DATE))