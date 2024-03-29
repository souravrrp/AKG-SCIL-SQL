SELECT
OOH.ORDER_NUMBER,
OOH.ORDERED_DATE,
OOL.ORDERED_QUANTITY,
OOL.FLOW_STATUS_CODE Order_Line_Status,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
FLV.DESCRIPTION MOVE_ORDER_NUMBER,
OOL.ORDERED_ITEM,
OOL.ORDER_QUANTITY_UOM "UNIT OF MEASURE"
--,OOL.SHIP_TO_ORG_ID,OOH.*
,OOD.ORGANIZATION_CODE
from
APPS.OE_ORDER_LINES_ALL OOL
,APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.FND_LOOKUP_VALUES FLV
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
--AND OOL.ORG_ID=85
AND OOD.ORGANIZATION_ID=OOL.SHIP_FROM_ORG_ID
AND OOL.SHIPMENT_PRIORITY_CODE=FLV.MEANING
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.SHIPMENT_PRIORITY_CODE=:P_SHIPMENT_PRIORITY_CODE--'DO/SCOU/876006'
--AND OOL.SHIPMENT_PRIORITY_CODE IS NULL
--AND OOL.FLOW_STATUS_CODE!='CANCELLED'
AND OOL.ORDER_QUANTITY_UOM IN ('BAG','MTN')
--AND TO_CHAR (OOH.ORDERED_DATE, 'RRRR') = '2017'
--AND OOH.ORDERED_DATE<='30-NOV-2017'-- between '01-JAN-2017' and '31-OCT-2017'
ORDER BY OOH.ORDERED_DATE DESC
