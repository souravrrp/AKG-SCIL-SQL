SELECT
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.ORDER_NUMBER,
--DODL.INVENTORY_ITEM_ID,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
DOH.DO_NUMBER,
DOH.DO_STATUS,
MOH.MOV_ORDER_NO,
MOH.MOV_ORDER_STATUS,
DODL.LINE_QUANTITY DO_QUANTITY,
DECODE (DODL.LINE_QUANTITY- OOL.INVOICED_QUANTITY, 0, ' ',DODL.LINE_QUANTITY) "PENDING QUANTITY",
OOL.INVOICED_QUANTITY,
DODL.UOM_CODE,
TO_CHAR (DOH.DO_DATE, 'DD-MON-YYYY') DO_DATE,
DODL.WAREHOUSE_ORG_ID,
DODL.WAREHOUSE_ORG_CODE,
DECODE (WDD.RELEASED_STATUS, 'B', 'Backordered', 
                             'D', 'Cancelled', 
                             'X', 'Not Applicable', 
                             'I', 'Interfaced',
                             'R', 'Ready to Release',
                             'C', 'Shipped',
                             'Y', 'Staged/Pick Confirmed',
                                'Non Defined') "RELEASED_STATUS",
OOL.FLOW_STATUS_CODE,
DOH.MODE_OF_TRANSPORT,
TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'DD-MON-YYYY') ACTUAL_SHIPMENT_DATE
FROM
APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL OOL,
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL,
XXAKG.XXAKG_MOV_ORD_HDR MOH,
XXAKG.XXAKG_MOV_ORD_DTL MODT,
APPS.WSH_DELIVERY_DETAILS WDD
WHERE 1=1
AND OOH.HEADER_ID=WDD.SOURCE_HEADER_ID
AND OOL.LINE_ID=WDD.SOURCE_LINE_ID
AND OOH.HEADER_ID=OOL.HEADER_ID
AND DODL.ORDER_HEADER_ID=OOH.HEADER_ID
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DODL.ORDER_LINE_ID=OOL.LINE_ID
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND OOL.SHIPMENT_PRIORITY_CODE=WDD.SHIPMENT_PRIORITY_CODE
AND DODL.WAREHOUSE_ORG_ID IN (1345,1346)
--AND MOH.MOV_ORDER_NO='MO/SCOU/870782'
--AND DOH.DO_NUMBER='DO/SCOU/871768'
--AND DODL.ITEM_NUMBER LIKE '%SCRP.%'
--AND OOH.ORDER_TYPE_ID=1101
--AND OOH.SHIP_FROM_ORG_ID=805




SELECT 
MVH.ORG_ID,
DODL.ORDER_NUMBER,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
DODL.UOM_CODE,
SOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
TRUNC (DO_DATE) DO_DATE,
DOH.DO_STATUS,
NVL (LINE_QUANTITY, 0) DO_QUANTITY,
WSHD.RELEASED_STATUS,
WSHD.RELEASED_STATUS_NAME,
SOL.FLOW_STATUS_CODE,
DODL.WAREHOUSE_ORG_ID,
DODL.WAREHOUSE_ORG_CODE,
MVH.MOV_ORDER_NO,
TRUNC (MOV_ORDER_DATE) MOV_ORDER_DATE,
MOV_ORDER_STATUS,
MVH.TRANSPORT_MODE,
SOL.ACTUAL_SHIPMENT_DATE
FROM APPS.XXAKG_DEL_ORD_HDR DOH,
          APPS.XXAKG_DEL_ORD_DO_LINES DODL,
          APPS.XXAKG_MOV_ORD_DTL MVD,
          APPS.XXAKG_MOV_ORD_HDR MVH,
          APPS.OE_ORDER_LINES_ALL SOL,
          --WSH_DELIVERY_DETAILS WSHD
          APPS.WSH_DELIVERABLES_V WSHD
    WHERE     DOH.DO_HDR_ID = DODL.DO_HDR_ID
          AND DOH.ORG_ID = DODL.ORG_ID
          AND DOH.DO_HDR_ID = MVD.DO_HDR_ID
          AND MVH.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
          AND MVH.ORG_ID = DOH.ORG_ID
          AND MVD.DO_NUMBER = SOL.SHIPMENT_PRIORITY_CODE
          AND MVH.ORG_ID = SOL.ORG_ID
          AND DODL.ORDER_HEADER_ID = SOL.HEADER_ID
          AND DODL.ORDER_LINE_ID = SOL.LINE_ID
          AND SOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
          AND SOL.LINE_ID = WSHD.SOURCE_LINE_ID
          AND DODL.WAREHOUSE_ORG_ID IN (1345,1346)
   UNION ALL
   SELECT 
   MVH.ORG_ID,
   DODL.ORDER_NUMBER,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
DODL.UOM_CODE,
SOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
TRUNC (DO_DATE) DO_DATE,
DOH.DO_STATUS,
NVL (LINE_QUANTITY, 0) DO_QUANTITY,
WSHD.RELEASED_STATUS,
WSHD.RELEASED_STATUS_NAME,
SOL.FLOW_STATUS_CODE,
DODL.WAREHOUSE_ORG_ID,
DODL.WAREHOUSE_ORG_CODE,
MVH.MOV_ORDER_NO,
TRUNC (MOV_ORDER_DATE) MOV_ORDER_DATE,
MOV_ORDER_STATUS,
MVH.TRANSPORT_MODE,
SOL.ACTUAL_SHIPMENT_DATE
     FROM APPS.XXAKG_DEL_ORD_HDR DOH,
          APPS.XXAKG_DEL_ORD_DO_LINES DODL,
          APPS.XXAKG_MOV_ORD_DTL MVD,
          APPS.XXAKG_MOV_ORD_HDR MVH,
          APPS.OE_ORDER_LINES_ALL SOL,
          --WSH_DELIVERY_DETAILS WSHD
          APPS.WSH_DELIVERABLES_V WSHD
    WHERE     DOH.DO_HDR_ID = DODL.DO_HDR_ID
          AND DOH.ORG_ID = DODL.ORG_ID
          AND DOH.DO_HDR_ID = MVD.DO_HDR_ID
          AND MVH.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
          AND MVH.ORG_ID = DOH.ORG_ID
          AND MVD.DO_NUMBER = SOL.SHIPMENT_PRIORITY_CODE
          AND MVH.ORG_ID = SOL.ORG_ID
          AND DODL.ORDER_HEADER_ID = SOL.HEADER_ID
          AND SOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
          AND SOL.LINE_ID = WSHD.SOURCE_LINE_ID
          AND DODL.WAREHOUSE_ORG_ID IN (1345,1346)
          AND NOT EXISTS
                (SELECT 1
                   FROM XXAKG_DEL_ORD_DO_LINES DOL1
                  WHERE DOL1.ORDER_LINE_ID = SOL.LINE_ID
                        AND DOL1.ORG_ID = SOL.ORG_ID);
