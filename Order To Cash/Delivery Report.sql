SELECT DISTINCT
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) DO_QUANTITY,
--MOH.MOV_ORDER_NO,
DODL.WAREHOUSE_ORG_CODE,
TO_CHAR (MOH.MOV_ORDER_DATE, 'DD-MON-YYYY') MOV_ORDER_DATE
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND DOH.ORG_ID=85
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
AND DOH.DO_HDR_ID=MODT.DO_HDR_ID
AND DODL.DO_NUMBER=MODT.DO_NUMBER
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.header_id=dODl.order_header_id and ol.shipment_priority_code=dOh.do_number and ol.org_id=dOh.org_id and ol.flow_status_code IN ('CLOSED','SHIPPED') and oh.order_type_id=1099)
AND DODL.WAREHOUSE_ORG_CODE='SCI'
and MOH.MOV_ORDER_STATUS='CONFIRMED'
AND MOH.CONFIRMED_DATE BETWEEN '15-OCT-2017' and '16-OCT-2017'
--AND TO_CHAR (MOH.CONFIRMED_DATE, 'MON-RR') = 'SEP-17'
AND DOH.CUSTOMER_NUMBER IN ('20107','20770','184363') 
GROUP BY
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.DO_NUMBER,
--MOH.MOV_ORDER_NO,
DODL.WAREHOUSE_ORG_CODE,
MOH.MOV_ORDER_DATE
