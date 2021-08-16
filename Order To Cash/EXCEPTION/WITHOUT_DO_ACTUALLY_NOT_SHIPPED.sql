SELECT HZP.PARTY_NAME,HCA.ACCOUNT_NUMBER CUSTOMER_NUMBER,OOH.ORDER_NUMBER,
OOL.ORDERED_QUANTITY,
DECODE(ool.shipment_priority_code,' ','NULL','NULL')DO_NUMBER,
OOL.FLOW_STATUS_CODE
FROM
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH
,APPS.HZ_CUST_ACCOUNTS HCA
,APPS.HZ_PARTIES HZP
WHERE 1=1
AND HZP.PARTY_ID=HCA.PARTY_ID
AND OOH.SOLD_TO_ORG_ID=HCA.CUST_ACCOUNT_ID
AND OOH.ORG_ID=85
AND OOH.HEADER_ID=OOL.HEADER_ID
--AND OOH.ORDER_NUMBER IN ('1655586')
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
--AND OOL.FLOW_STATUS_CODE NOT IN ('CLOSED','CANCELLED','ENTERED','AWAITING_SHIPPING','AWAITING_RETURN_DISPOSITION','AWAITING_RETURN','BOOKED','SHIPPED','FULFILLED','RETURNED')
--AND OOL.SHIPMENT_PRIORITY_CODE=:P_SHIPMENT_PRIORITY_CODE
AND OOL.SHIPMENT_PRIORITY_CODE IS NULL
AND OOL.ACTUAL_SHIPMENT_DATE IS NOT NULL
--AND NVL(ool.shipment_priority_code,0)='NULL'
AND OOH.ORDER_TYPE_ID=1099