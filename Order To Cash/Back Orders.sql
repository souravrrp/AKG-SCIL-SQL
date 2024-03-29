/* Formatted on 5/22/2019 3:15:40 PM (QP5 v5.287) */
  SELECT OOL.ORG_ID,
         DBM.REGION_NAME,
         DOH.CUSTOMER_NUMBER,
         DOH.CUSTOMER_NAME,
         WDD.SHIPMENT_PRIORITY_CODE DO_NUMBER,
         MOH.MOV_ORDER_NO,
         DOH.MODE_OF_TRANSPORT,
         OOL.ORDERED_ITEM,
         WDD.ITEM_DESCRIPTION,
         ORG.ORGANIZATION_NAME,
         ORG.ORGANIZATION_CODE ORG_CODE,
         OOL.ORDERED_QUANTITY QUANTITY,
         OOL.ORDER_QUANTITY_UOM UOM,
         TO_CHAR (DOH.DO_DATE) DO_DATE
    --,OOL.ACTUAL_SHIPMENT_DATE
    FROM APPS.OE_ORDER_LINES_ALL OOL,
         APPS.OE_ORDER_HEADERS_ALL OOH,
         WSH.WSH_DELIVERY_DETAILS WDD,
         APPS.ORG_ORGANIZATION_DEFINITIONS ORG,
         APPS.XXAKG_DEL_ORD_DO_LINES DODL,
         APPS.XXAKG_DEL_ORD_HDR DOH,
         XXAKG.XXAKG_MOV_ORD_HDR MOH,
         XXAKG.XXAKG_MOV_ORD_DTL MODT,
         APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM
   WHERE     1 = 1
         AND OOH.ORG_ID = OOL.ORG_ID
         AND DOH.DO_NUMBER = MODT.DO_NUMBER
         AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
         AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
         AND DOH.DO_HDR_ID = DODL.DO_HDR_ID
         AND DODL.ORDER_HEADER_ID = OOH.HEADER_ID
         AND OOH.HEADER_ID = WDD.SOURCE_HEADER_ID
         AND OOL.LINE_ID = WDD.SOURCE_LINE_ID
         AND ORG.ORGANIZATION_ID = OOL.SHIP_FROM_ORG_ID
         AND DBM.CUSTOMER_NUMBER = DOH.CUSTOMER_NUMBER
         AND WDD.RELEASED_STATUS = 'B'
         AND OOL.ORG_ID = 85
         --AND ORG.ORGANIZATION_CODE='SCI'
         AND OOL.ORDER_QUANTITY_UOM IN ('BAG', 'MTN')
--AND DOH.DO_DATE<'01-NOV-2018'
--AND DOH.DO_DATE BETWEEN '01-JAN-2011' and '31-OCT-2017'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'OCT-18'
ORDER BY DOH.DO_DATE DESC;


SELECT *
  FROM APPS.XXAKG_BACK_ORDERED_QUANTITY_V
 WHERE 1 = 1 AND TO_CHAR (ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'SEP-17';

SELECT DO.ORG_ID,
       ORG.ORGANIZATION_NAME,
       ORG.ORGANIZATION_CODE,
       DO.SHIPMENT_PRIORITY_CODE DO_NUMBER,
       DO.ACTUAL_SHIPMENT_DATE,
       (DO.ORDERED_QUANTITY - SHIPPED.SHIPPED_QUANTITY) BACK_ORDERED_QUANTITY
  FROM (  SELECT SHIPMENT_PRIORITY_CODE,
                 ORG_ID,
                 OEL.SHIP_FROM_ORG_ID,
                 MAX (TRUNC (ACTUAL_SHIPMENT_DATE)) ACTUAL_SHIPMENT_DATE,
                 SUM (OEL.ORDERED_QUANTITY) ORDERED_QUANTITY
            FROM APPS.OE_ORDER_LINES_ALL OEL
           WHERE ORG_ID = 85
        GROUP BY SHIPMENT_PRIORITY_CODE, ORG_ID, OEL.SHIP_FROM_ORG_ID) DO,
       (  SELECT OEL.SHIPMENT_PRIORITY_CODE,
                 OEL.ORG_ID,
                 SUM (NVL (OEL.SHIPPED_QUANTITY, 0)) SHIPPED_QUANTITY
            FROM APPS.OE_ORDER_LINES_ALL OEL, APPS.WSH_DELIVERY_DETAILS WSHD
           WHERE     OEL.LINE_ID = WSHD.SOURCE_LINE_ID
                 AND OEL.ORG_ID = WSHD.ORG_ID
                 AND OEL.ORG_ID = 85
                 AND WSHD.RELEASED_STATUS = 'C'
        GROUP BY OEL.SHIPMENT_PRIORITY_CODE, OEL.ORG_ID) SHIPPED,
       APPS.ORG_ORGANIZATION_DEFINITIONS ORG
 WHERE     DO.SHIPMENT_PRIORITY_CODE = SHIPPED.SHIPMENT_PRIORITY_CODE
       AND DO.ORG_ID = SHIPPED.ORG_ID
       AND DO.SHIP_FROM_ORG_ID = ORG.ORGANIZATION_ID
       AND (DO.ORDERED_QUANTITY - SHIPPED.SHIPPED_QUANTITY) > 0;


SELECT *
  FROM APPS.WSH_DELIVERABLES_V
 WHERE 1 = 1 AND SHIPMENT_PRIORITY_CODE = 'DO/SCOU/1021212' AND ROWNUM <= 3;

  SELECT OOL.ORG_ID,
         DOH.CUSTOMER_NUMBER,
         DOH.CUSTOMER_NAME,
         WDD.SHIPMENT_PRIORITY_CODE,
         MOH.MOV_ORDER_NO,
         OOL.ORDERED_ITEM,
         WDD.ITEM_DESCRIPTION,
         ORG.ORGANIZATION_NAME,
         ORG.ORGANIZATION_CODE,
         OOL.ORDERED_QUANTITY QUANTITY,
         OOL.ORDER_QUANTITY_UOM UNIT_OF_MEASURE,
         TO_CHAR (DOH.DO_DATE) DO_DATE
    --,OOL.ACTUAL_SHIPMENT_DATE
    FROM APPS.OE_ORDER_LINES_ALL OOL,
         APPS.OE_ORDER_HEADERS_ALL OOH,
         WSH.WSH_DELIVERY_DETAILS WDD,
         APPS.ORG_ORGANIZATION_DEFINITIONS ORG,
         APPS.XXAKG_DEL_ORD_DO_LINES DODL,
         APPS.XXAKG_DEL_ORD_HDR DOH,
         XXAKG.XXAKG_MOV_ORD_HDR MOH,
         XXAKG.XXAKG_MOV_ORD_DTL MODT
   WHERE     OOH.ORG_ID = OOL.ORG_ID
         AND DOH.DO_NUMBER = MODT.DO_NUMBER
         AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
         AND DOH.DO_NUMBER = OOL.SHIPMENT_PRIORITY_CODE
         AND DOH.DO_HDR_ID = DODL.DO_HDR_ID
         AND DODL.ORDER_HEADER_ID = OOH.HEADER_ID
         AND OOH.HEADER_ID = WDD.SOURCE_HEADER_ID
         AND OOL.LINE_ID = WDD.SOURCE_LINE_ID
         AND ORG.ORGANIZATION_ID = OOL.SHIP_FROM_ORG_ID
         AND WDD.RELEASED_STATUS = 'B'
         AND OOL.ORG_ID = 85
         AND OOL.ORDER_QUANTITY_UOM IN ('BAG', 'MTN')
--AND DOH.DO_DATE BETWEEN '01-JAN-2011' and '31-OCT-2017'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'OCT-17'
ORDER BY DOH.DO_DATE DESC