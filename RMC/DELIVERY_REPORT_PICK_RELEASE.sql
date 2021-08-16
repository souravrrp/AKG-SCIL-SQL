SELECT 
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
OOH.ORDER_NUMBER,
OOH.ORDERED_DATE,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
OOD.ORGANIZATION_NAME,
DODL.WAREHOUSE_ORG_CODE,
MOH.MOV_ORDER_NO,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
NVL (LINE_QUANTITY, 0) DO_QUANTITY,
WPB.NAME BATCH_NO,
NVL(MODT.VAT_CHALLAN_NO,0) VAT_CHALLAN_NO,
TO_CHAR(MODT.VAT_CHALLAN_DATE) VAT_CHALLAN_DATE,
OOL.FLOW_STATUS_CODE ORDER_LINE_STATUS,
WSHD.RELEASED_STATUS_NAME DELIVERY_STATUS,
DOH.DO_STATUS,
MOH.MOV_ORDER_STATUS
FROM APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL OOL, APPS.XXAKG_DEL_ORD_HDR DOH,
          APPS.XXAKG_DEL_ORD_DO_LINES DODL,
          APPS.XXAKG_MOV_ORD_DTL MODT,
          APPS.XXAKG_MOV_ORD_HDR MOH,
          APPS.WSH_DELIVERABLES_V WSHD,
          APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
          APPS.WSH_PICKING_BATCHES WPB,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD
    WHERE    1=1
    AND OOH.HEADER_ID=OOL.HEADER_ID
    AND OOL.HEADER_ID=DODL.ORDER_HEADER_ID
    AND OOL.LINE_ID=DODL.ORDER_LINE_ID
    AND    DOH.DO_HDR_ID = DODL.DO_HDR_ID
          AND DOH.ORG_ID = DODL.ORG_ID
          AND DOH.DO_HDR_ID = MODT.DO_HDR_ID
          AND MOH.MOV_ORD_HDR_ID = MODT.MOV_ORD_HDR_ID
          AND MOH.ORG_ID = DOH.ORG_ID
          AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
          AND MOH.ORG_ID = OOL.ORG_ID
          AND DODL.ORDER_HEADER_ID = OOL.HEADER_ID
          AND DODL.ORDER_LINE_ID = OOL.LINE_ID
          AND OOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
          AND OOL.LINE_ID = WSHD.SOURCE_LINE_ID
          AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
          AND WSHD.BATCH_ID=WPB.BATCH_ID
          AND DODL.WAREHOUSE_ORG_ID=OOD.ORGANIZATION_ID
           AND OOH.ORG_ID=84
          AND WSHD.RELEASED_STATUS_NAME='Staged/Pick Confirmed'
--          AND DODL.WAREHOUSE_ORG_CODE='RMC'
          AND TO_CHAR (MOH.confirmed_date, 'MON-RR') = 'FEB-18'
--          AND DOH.DO_NUMBER=:P_DO_NUMBER
--            AND DODL.ORDER_NUMBER=:P_ORDER_NUMBER
UNION ALL
SELECT 
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
OOH.ORDER_NUMBER,
OOH.ORDERED_DATE,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
OOD.ORGANIZATION_NAME,
DODL.WAREHOUSE_ORG_CODE,
MOH.MOV_ORDER_NO,
DODL.ITEM_NUMBER,
DODL.ITEM_DESCRIPTION,
NVL (LINE_QUANTITY, 0) DO_QUANTITY,
WPB.NAME BATCH_NO,
NVL(MODT.VAT_CHALLAN_NO,0) VAT_CHALLAN_NO,
TO_CHAR(MODT.VAT_CHALLAN_DATE) VAT_CHALLAN_DATE,
OOL.FLOW_STATUS_CODE ORDER_LINE_STATUS,
WSHD.RELEASED_STATUS_NAME DELIVERY_STATUS,
DOH.DO_STATUS,
MOH.MOV_ORDER_STATUS
     FROM  APPS.OE_ORDER_HEADERS_ALL OOH,
           APPS.OE_ORDER_LINES_ALL OOL,
           APPS.XXAKG_DEL_ORD_HDR DOH,
          APPS.XXAKG_DEL_ORD_DO_LINES DODL,
          APPS.XXAKG_MOV_ORD_DTL MODT,
          APPS.XXAKG_MOV_ORD_HDR MOH,
          APPS.WSH_DELIVERABLES_V WSHD,
          APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
          APPS.WSH_PICKING_BATCHES WPB,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD
    WHERE  1=1
    AND OOH.HEADER_ID=OOL.HEADER_ID
    AND OOL.HEADER_ID=DODL.ORDER_HEADER_ID
    AND OOL.LINE_ID=DODL.ORDER_LINE_ID
    AND   DOH.DO_HDR_ID = DODL.DO_HDR_ID
          AND DOH.ORG_ID = DODL.ORG_ID
          AND DOH.DO_HDR_ID = MODT.DO_HDR_ID
          AND MOH.MOV_ORD_HDR_ID = MODT.MOV_ORD_HDR_ID
          AND MOH.ORG_ID = DOH.ORG_ID
          AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
          AND MOH.ORG_ID = OOL.ORG_ID
          AND DODL.ORDER_HEADER_ID = OOL.HEADER_ID
          AND OOL.HEADER_ID = WSHD.SOURCE_HEADER_ID
          AND OOL.LINE_ID = WSHD.SOURCE_LINE_ID
          AND DOH.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
          AND WSHD.BATCH_ID=WPB.BATCH_ID
          AND DODL.WAREHOUSE_ORG_ID=OOD.ORGANIZATION_ID
          AND OOH.ORG_ID=84
          AND WSHD.RELEASED_STATUS_NAME='Staged/Pick Confirmed'
--          AND DODL.WAREHOUSE_ORG_CODE='RMC'
          AND TO_CHAR (MOH.confirmed_date, 'MON-RR') = 'FEB-18'
--          AND DOH.DO_NUMBER=:P_DO_NUMBER
--            AND DODL.ORDER_NUMBER=:P_ORDER_NUMBER
          AND NOT EXISTS
                (SELECT 1
                   FROM XXAKG_DEL_ORD_DO_LINES DOL1
                  WHERE DOL1.ORDER_LINE_ID = OOL.LINE_ID
                        AND DOL1.ORG_ID = OOL.ORG_ID);