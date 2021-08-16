------------------------------Order Details---------------------------------------------------
SELECT 
OOH.ORG_ID,
APPS.XXAKG_COM_PKG.GET_ORGANIZATION_NAME (OOH.ORG_ID) OPERATING_UNIT,
APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOH.SOLD_TO_ORG_ID) REGION, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (OOH.SOLD_TO_ORG_ID) CUSTOMER_NUMBER, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_FROM_ID (OOH.SOLD_TO_ORG_ID) CUSTOMER_NAME,
OOL.ORDERED_ITEM,
(CASE 
          WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN (SUM(OOL.SHIPPED_QUANTITY)*1000)/50
            ELSE SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', OOL.SHIPPED_QUANTITY*20,'BAG', OOL.SHIPPED_QUANTITY))
END) "Quantity in BAG",
(CASE 
          WHEN  OOL.ORDERED_ITEM='CMNT.OBAG.0004' THEN ((SUM(OOL.SHIPPED_QUANTITY)*1000)/50)*OOL.UNIT_SELLING_PRICE
            ELSE SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', (OOL.SHIPPED_QUANTITY*20)*OOL.UNIT_SELLING_PRICE,'BAG', (OOL.SHIPPED_QUANTITY*OOL.UNIT_SELLING_PRICE)))
END) "SALES_VALUE"
,TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') MONTH_OF_PERIOD
--,(OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY) AMOUNT
--,OOH.*
--,OOL.*
FROM
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
WHERE 1=1 
AND OOH.HEADER_ID=OOL.HEADER_ID
AND ((:P_ORG_ID IS NULL AND OOH.ORG_ID IN (83,84,85,605)) OR (OOH.ORG_ID=:P_ORG_ID))
--AND APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (OOH.SOLD_TO_ORG_ID)= :P_CUSTOMER_NUMBER
AND APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOH.SOLD_TO_ORG_ID) IN ('Corporate North','Corporate South','Institutional','MES')
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE) BETWEEN NVL(:P_INVOICE_DATE_FROM,TRUNC(OOL.ACTUAL_SHIPMENT_DATE)) AND NVL(:P_INVOICE_DATE_TO,TRUNC(OOL.ACTUAL_SHIPMENT_DATE))
GROUP BY 
OOH.ORG_ID,
OOL.ORDERED_ITEM, 
TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR'),
OOH.SOLD_TO_ORG_ID

--------------------------------------------------------------------------------

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
ORD.ORG_ID,
APPS.XXAKG_COM_PKG.GET_ORGANIZATION_NAME (ORD.ORG_ID) OPERATING_UNIT,
APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (ORD.SOLD_TO_ORG_ID) REGION, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (ORD.SOLD_TO_ORG_ID) CUSTOMER_NUMBER, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_FROM_ID (ORD.SOLD_TO_ORG_ID) CUSTOMER_NAME,
(CASE 
          WHEN  ORD.ORDERED_ITEM='CMNT.OBAG.0004' THEN (SUM(ORD.SHIPPED_QUANTITY)*1000)/50
            ELSE SUM(DECODE (ORD.ORDER_QUANTITY_UOM, 'MTN', ORD.ORDERED_QUANTITY*20,'BAG', ORD.ORDERED_QUANTITY))
END) "Quantity in BAG"
,SUM(ORDERED_AMT) AMOUNT
,PERIOD
--SUM(SHIPPED_QUANTITY) SHIPPED_QUANTITY,
--SUM(INVOICED_QUANTITY) INVOICED_QUANTITY
--SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', SHIPPING_QUANTITY*20,
--                                        'BAG', SHIPPING_QUANTITY)) SHIPPING_QUANTITY,
--SUM(DECODE (ORDER_QUANTITY_UOM, 'MTN', INVOICED_QUANTITY*20,
--                                        'BAG', INVOICED_QUANTITY)) INVOICED_QUANTITY
--SUM(SHIPPING_QUANTITY) SHIPPING_QUANTITY,
--SUM(INVOICED_QUANTITY) INVOICED_QUANTITY
--DELIVERY_DATE,
--FLOW_STATUS_CODE,
--ORD.*
FROM
APPS.XXAKG_HEADER_DETAIL_V ORD
WHERE 1=1
AND ORG_ID=85
--AND ORGANIZATION_CODE!='G10'
--AND PERIOD='JAN-19'
--AND ORDER_QUANTITY_UOM='MTN'
--AND DELIVERY_DATE BETWEEN '01-JAN-18' AND '30-NOV-19'
AND FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
AND APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (ORD.SOLD_TO_ORG_ID) IN ('Corporate North','Corporate South','Institutional','MES','MES 2019')
--AND EXISTS(SELECT 1 FROM APPS.XXAKG_DEL_ORD_HDR DOH WHERE DOH.DO_NUMBER=ORD.DO_NUMBER AND DOH.MODE_OF_TRANSPORT='Company Truck')
GROUP BY 
ORD.ORG_ID,
ORD.ORDERED_ITEM, 
PERIOD,
ORD.SOLD_TO_ORG_ID
--ORGANIZATION_NAME
--,ORGANIZATION_CODE
--,DO_NUMBER
--,ORD.ORDERED_ITEM_ID
--,ORD.SHIP_FROM_ORG_ID