SELECT
OOL.ORG_ID, 
OOH.ORDER_NUMBER,
OOH.ORDER_TYPE_ID,
OOH.ORDERED_DATE,
OOL.HEADER_ID, 
OOL.ORDERED_ITEM, 
OOL.ORDER_QUANTITY_UOM,
OOL.FLOW_STATUS_CODE, 
OOL.ATTRIBUTE10 LOCATION,
OOL.ATTRIBUTE11 TRANSPORT_MODE,
OOL.ATTRIBUTE13 DELIVERY_SITE,
SUM(OOL.SHIPPED_QUANTITY) TOTAL_SHIPPED_QUANTITY,
sum(OOL.SHIPPING_QUANTITY) TOTAL_SHIPPING_QUANTITY,
sum(OOL.ORDERED_QUANTITY) TOTAL_ORDERED_QUANTITY
--OOL.INVOICED_QUANTITY,
--OOL.ACTUAL_SHIPMENT_DATE
FROM 
APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL  OOL
WHERE ORDER_NUMBER IN ('1596934')
AND OOL.HEADER_ID=OOH.HEADER_ID
GROUP BY 
OOL.ORG_ID, 
OOH.ORDER_NUMBER,
OOH.ORDER_TYPE_ID,
OOH.ORDERED_DATE,
OOL.HEADER_ID, 
OOL.ORDERED_ITEM, 
OOL.ORDER_QUANTITY_UOM,
OOL.ATTRIBUTE10,
OOL.ATTRIBUTE11,
OOL.ATTRIBUTE13,
OOL.FLOW_STATUS_CODE 