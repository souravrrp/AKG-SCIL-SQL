SELECT
DOH.DO_NUMBER, 
/*
DECODE(MSI.SEGMENT2,'PBAG','PP',
                                    'SBAG','SP',
                                    'OBAG','OPC',
                                    'NULL') ITEM,
                                    */
SUM(DODL.LINE_QUANTITY) DO_QUANTITY,
DODL.ITEM_DESCRIPTION,
SUM(AIA.INVOICE_AMOUNT) INVOICE_AMOUNT
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
APPS.XXAKG_MOV_ORD_DTL MODT,
APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.AP_INVOICES_ALL AIA--,
--APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND DOH.ORG_ID=85
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DOH.DO_HDR_ID=MODT.DO_HDR_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
--AND MOH.MOV_ORDER_NO=AIA.INVOICE_NUM
--AND DODL.ORDERED_ITEM_ID=MSI.INVENTORY_ITEM_ID
AND DODL.UOM_CODE='BAG'
--AND MSI.SEGMENT1='CMNT'
--AND TO_CHAR (AIA.CREATION_DATE, 'MON-RR') = 'SEP-17'
AND AIA.CREATION_DATE BETWEEN '01-AUG-2017' and '21-AUG-2017'
--and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.header_id=dODl.order_header_id and ol.shipment_priority_code=dOh.do_number and ol.org_id=dOh.org_id and ol.flow_status_code IN ('CLOSED','SHIPPED') and oh.order_type_id=1099)
GROUP BY
DOH.DO_NUMBER, 
DODL.ITEM_DESCRIPTION--,
--MSI.SEGMENT2

