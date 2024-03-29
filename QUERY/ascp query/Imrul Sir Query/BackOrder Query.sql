SELECT 
OOL.ORG_ID,
WDD.SHIPMENT_PRIORITY_CODE,
OOL.ORDERED_ITEM,
WDD.ITEM_DESCRIPTION,
ORG.ORGANIZATION_NAME,
ORG.ORGANIZATION_CODE,
OOL.ORDERED_QUANTITY QUANTITY
FROM 
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH,
WSH.WSH_DELIVERY_DETAILS WDD,
APPS.ORG_ORGANIZATION_DEFINITIONS ORG
WHERE 
OOH.ORG_ID=OOL.ORG_ID
AND OOH.HEADER_ID=WDD.SOURCE_HEADER_ID
AND OOL.LINE_ID=WDD.SOURCE_LINE_ID
AND ORG.ORGANIZATION_ID= OOL.SHIP_FROM_ORG_ID
AND WDD.RELEASED_STATUS='B'
AND OOL.ORG_ID=83
AND TO_CHAR (OOH.ORDERED_DATE, 'MON-RR') = 'AUG-17'
