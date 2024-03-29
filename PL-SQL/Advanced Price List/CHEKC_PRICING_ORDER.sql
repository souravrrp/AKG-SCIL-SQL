SELECT 
--OOH.HEADER_ID,
--OOL.LINE_ID,
CUST.CUSTOMER_NUMBER,
CUST.CUSTOMER_NAME,
OOH.ORDER_NUMBER,
(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=OOL.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=OOL.SHIP_FROM_ORG_ID) ITEM_CODE,
--OOH.ORDER_TYPE_ID,
TO_CHAR(OOH.ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS') ORDERED_DATE,
TO_CHAR(OOH.CREATION_DATE,'DD-MON-YYYY HH24:MI:SS') ORDER_CREATION_DATE,
TO_CHAR(OOH.BOOKED_DATE,'DD-MON-YYYY HH24:MI:SS') ORDER_BOOKED_DATE,
TO_CHAR(OOL.PRICING_DATE,'DD-MON-YYYY HH24:MI:SS') ORDER_PRICING_DATE,
OOL.ORDERED_QUANTITY,
(OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY) AMOUNT,
OOL.SHIPPED_QUANTITY,
OOL.INVOICED_QUANTITY,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
OOL.FLOW_STATUS_CODE
,OOL.ACTUAL_SHIPMENT_DATE
,OOL.UNIT_SELLING_PRICE
,OOL.UNIT_LIST_PRICE
,OOL.ATTRIBUTE10 PRICE_LOCATION
,DIS.LIST_LINE_NO MODIFIER_LINE_NO
,DIS.OPERAND_PER_PQTY "Discount/Over Rate"
,DIS.ADJUSTED_AMOUNT_PER_PQTY "Amount Adjusted"
,ADJUSTMENT_NAME
,DECODE(DIS.ARITHMETIC_OPERATOR,'AMT','Price Discount','NEWPRICE','Over Sales Price','Company Rate') MODIFIER_Name
--,decode(greatest(DIS.ADJUSTED_AMOUNT_PER_PQTY,0), 0,'Price Discount','Over Sales Price') MODIFIER_Name--RMC
--,OOH.*
--,OOL.*
--,CUST.*
--,DIS.*
FROM
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.XXAKG_REGION_BLOCK_CELL_V CUST
,APPS.OE_PRICE_ADJUSTMENTS_V DIS
WHERE 1=1 
AND OOH.HEADER_ID=DIS.HEADER_ID(+)
AND OOL.LINE_ID=DIS.LINE_ID(+)
AND CUST.CUSTOMER_ID=OOL.SOLD_TO_ORG_ID
AND CUST.SHIP_SITE_LOCATION_ID=OOL.SHIP_TO_ORG_ID
AND OOH.HEADER_ID=OOL.HEADER_ID
AND     (:P_ORG_ID IS NULL OR (OOH.ORG_ID = :P_ORG_ID))
AND     (:P_CUSTOMER_NUMBER IS NULL OR (CUST.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
AND     (:P_ORDER_NUMBER IS NULL OR (OOH.ORDER_NUMBER = :P_ORDER_NUMBER))
--AND TRUNC(OOH.ORDERED_DATE) BETWEEN NVL(:P_DATE_FROM,TRUNC(OOH.ORDERED_DATE)) AND NVL(:P_DATE_TO,TRUNC(OOH.ORDERED_DATE))
--AND     TO_CHAR (OOH.ORDERED_DATE, 'DD-MON-RR') = '29-APR-18'
--AND OOL.ORDERED_ITEM='CMNT.OBAG.0004'
--AND OOL.ORDER_QUANTITY_UOM='MTN'
--AND OOL.FLOW_STATUS_CODE='AWAITING_SHIPPING'-- NOT IN ('CLOSED','CANCELLED','ENTERED','AWAITING_SHIPPING','AWAITING_RETURN_DISPOSITION','AWAITING_RETURN','BOOKED','SHIPPED','FULFILLED','RETURNED')
--AND OOL.SHIPMENT_PRIORITY_CODE=:P_DO_NUMBER
--AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAY-18'
--AND ORDER_TYPE_ID=1101
--AND OOH.ORG_ID=84
--AND OOH.SHIP_FROM_ORG_ID=1346
ORDER BY OOH.ORDERED_DATE DESC


SELECT
*
FROM
APPS.OE_PRICE_ADJUSTMENTS
WHERE 1=1


