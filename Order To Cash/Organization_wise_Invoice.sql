SELECT
--ORGANIZATION_NAME,
--ORGANIZATION_CODE,
--ORDERED_DATE,
--ORDER_NUMBER,
--ORDERED_ITEM,
--DO_NUMBER,
--(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=ORD.ORDERED_ITEM_ID AND MSI.ORGANIZATION_ID=ORD.SHIP_FROM_ORG_ID) ITEM_NAME,
--ORDER_QUANTITY_UOM,
--UNIT_SELLING_PRICE,
--UNIT_LIST_PRICE,
--(CASE 
--          WHEN  ORD.ORDERED_ITEM='CMNT.OBAG.0004' THEN (SUM(ORD.SHIPPED_QUANTITY)*1000)/50
--            ELSE SUM(DECODE (ORD.ORDER_QUANTITY_UOM, 'MTN', ORD.ORDERED_QUANTITY*20,'BAG', ORD.ORDERED_QUANTITY))
--END) "Quantity in BAG"
SUM(SHIPPED_QUANTITY) SHIPPED_QUANTITY,
SUM(INVOICED_QUANTITY) INVOICED_QUANTITY
--SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', SHIPPING_QUANTITY*20,
--                                        'BAG', SHIPPING_QUANTITY)) SHIPPING_QUANTITY,
--SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', INVOICED_QUANTITY*20,
--                                        'BAG', INVOICED_QUANTITY)) INVOICED_QUANTITY
--SUM(SHIPPING_QUANTITY) SHIPPING_QUANTITY,
--SUM(INVOICED_QUANTITY) INVOICED_QUANTITY
--SUM(ORDERED_AMT) AMOUNT
--DELIVERY_DATE,
--FLOW_STATUS_CODE,
--PERIOD
--ORD.*
FROM
APPS.XXAKG_HEADER_DETAIL_V ORD
WHERE 1=1
AND ORG_ID=84
--AND ORGANIZATION_CODE!='G10'
AND PERIOD='SEP-19'
--AND ORDER_QUANTITY_UOM='MTN'
--AND DELIVERY_DATE BETWEEN '01-SEP-18' AND '30-SEP-18'
AND FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
--AND EXISTS(SELECT 1 FROM APPS.XXAKG_DEL_ORD_HDR DOH WHERE DOH.DO_NUMBER=ORD.DO_NUMBER AND DOH.MODE_OF_TRANSPORT='Company Truck')
--GROUP BY
--ORGANIZATION_NAME
--,ORGANIZATION_CODE
--,DO_NUMBER
--,ORD.ORDERED_ITEM_ID
--,ORD.SHIP_FROM_ORG_ID


----------------------------****************------------------------------------------

SELECT
--OOH.ORDER_NUMBER,
--OOL.ORDERED_ITEM,
--MSIB.DESCRIPTION,
--OOL.ORDER_QUANTITY_UOM UOM,
--SUM(OOL.ORDERED_QUANTITY) QUANTITY,
--SUM(SHIPPED_QUANTITY) SHIPPED_QUANTITY,
--SUM(INVOICED_QUANTITY) INVOICED_QUANTITY
(CASE 
          WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (SUM(OOL.ORDERED_QUANTITY)*1000)/50
            ELSE SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', OOL.ORDERED_QUANTITY*20,'BAG', OOL.ORDERED_QUANTITY))
END) "Quantity in BAG",
SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', SHIPPING_QUANTITY*20,
                                        'BAG', SHIPPING_QUANTITY)) SHIPPING_QUANTITY,
SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', INVOICED_QUANTITY*20,
                                        'BAG', INVOICED_QUANTITY)) INVOICED_QUANTITY
--OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
--OOH.ORDERED_DATE,
--OOL.SHIP_FROM_ORG_ID ORGANIZATION_ID,
--OOD.ORGANIZATION_CODE,
--OOL.FLOW_STATUS_CODE,
--OOH.FLOW_STATUS_CODE ORDER_STATUS,
--OOL.UNIT_SELLING_PRICE,
--(OOL.UNIT_SELLING_PRICE*SUM(OOL.ORDERED_QUANTITY)) AMOUNT
--,OOL.*
FROM
APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.OE_ORDER_LINES_ALL OOL
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
,APPS.MTL_SYSTEM_ITEMS_B MSIB
WHERE 1=1
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.INVENTORY_ITEM_ID=MSIB.INVENTORY_ITEM_ID
AND OOL.SHIP_FROM_ORG_ID=MSIB.ORGANIZATION_ID
AND OOD.ORGANIZATION_ID=MSIB.ORGANIZATION_ID
AND OOL.FLOW_STATUS_CODE IN ('SHIPPED','CLOSED')--='AWAITING_SHIPPING'
AND OOH.FLOW_STATUS_CODE IN ('CLOSED','BOOKED')
--AND OOL.ORDER_QUANTITY_UOM IN ('MTN','BAG')
--AND OOH.ORDER_TYPE_ID=1105--1099
--AND OOL.ACTUAL_SHIPMENT_DATE BETWEEN '01-FEB-2018' AND '19-FEB-2018'
--AND OOL.FULFILLMENT_DATE BETWEEN '01-FEB-2018' AND '19-FEB-2018'
--AND TO_CHAR (OOL.FULFILLMENT_DATE, 'MON-RR') = 'FEB-18'
AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-19'
--AND TO_CHAR (DOH.ACTUAL_SHIPMENT_DATE, 'RRRR') = '2017'
--AND OOL.ACTUAL_SHIPMENT_DATE IS NOT NULL
--AND OOL.SHIPMENT_PRIORITY_CODE IS NOT NULL
AND OOH.ORG_ID=85
--AND OOH.ORDER_NUMBER=:P_ORDER_NUMBER
GROUP BY
--OOH.ORDER_NUMBER,
OOL.ORDERED_ITEM
--MSIB.DESCRIPTION,
--OOL.ORDER_QUANTITY_UOM,
--OOL.SHIPMENT_PRIORITY_CODE ,
--OOH.ORDERED_DATE,
--OOL.SHIP_FROM_ORG_ID ,
--OOD.ORGANIZATION_CODE,
--OOL.FLOW_STATUS_CODE,
--OOH.FLOW_STATUS_CODE ORDER_STATUS,
--OOL.UNIT_SELLING_PRICE,
--OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY
--,OOL.*

---------------------------------------------DETAILS-----------------------------------------
SELECT
DOH.CUSTOMER_NUMBER
,DOH.CUSTOMER_NAME
,MOH.MOV_ORDER_NO
,OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER
,(CASE 
          WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (SUM(OOL.ORDERED_QUANTITY)*1000)/50
            ELSE SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', OOL.ORDERED_QUANTITY*20,'BAG', OOL.ORDERED_QUANTITY))
END) "Quantity in BAG"
,OOL.ORDERED_ITEM
,OOD.ORGANIZATION_CODE
,OOL.FLOW_STATUS_CODE DELIVERY_STATUS
,MOH.VEHICLE_NO
,MOH.TRANSPORT_MODE
,TO_CHAR(MOH.CONFIRMED_DATE,'DD-MON-RR') MOVE_CONFIRMED_DATE
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
,XXAKG.XXAKG_MOV_ORD_DTL MODT
,APPS.OE_ORDER_LINES_ALL OOL
,APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND OOL.SHIP_FROM_ORG_ID=OOD.ORGANIZATION_ID
AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND OOL.SHIPMENT_PRIORITY_CODE=MODT.DO_NUMBER 
AND DOH.DO_STATUS='CONFIRMED'
AND MOH.MOV_ORDER_STATUS='CONFIRMED'
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')  --='AWAITING_SHIPPING'
AND MOH.ORG_ID=85
AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-19'
AND OOL.ORDER_QUANTITY_UOM IN ('MTN','BAG')
--AND WAREHOUSE_ORG_CODE='SCI'
--AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier','Company Truck')
--AND MOH.VEHICLE_NO LIKE '%2369%' --IN ('D.M.U-12-1695')
--AND MOH.MOV_ORDER_NO IN ('MO/SCOU/1220918')
--AND TO_CHAR(MOH.CONFIRMED_DATE,'DD-MON-RR')='31-DEC-18'
--AND TO_CHAR(MOH.CONFIRMED_DATE,'MON-RR')='DEC-18'
--AND TO_CHAR(MOH.CONFIRMED_DATE,'RRRR')='2018'
--AND MOH.CONFIRMED_DATE<='31-MAR-2019'
--AND DOH.DO_DATE BETWEEN '01-JAN-2010' and '30-APR-2018'
--AND TRUNC(MOH.MOV_ORDER_DATE) BETWEEN '28-NOV-2018' and '29-NOV-2018'
--AND TO_CHAR(MOH.GATE_OUT_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/NOV/28 06:00:00' AND '2018/NOV/29 09:40:00'--HH:MI:SS--12:00:00
GROUP BY
DOH.CUSTOMER_NUMBER
,DOH.CUSTOMER_NAME
,MOH.MOV_ORDER_NO
,OOL.SHIPMENT_PRIORITY_CODE
,OOL.ORDERED_ITEM
,OOD.ORGANIZATION_CODE
,OOL.FLOW_STATUS_CODE
,MOH.VEHICLE_NO
,MOH.TRANSPORT_MODE
,MOH.CONFIRMED_DATE
--ORDER BY OOL.ACTUAL_SHIPMENT_DATE DESC