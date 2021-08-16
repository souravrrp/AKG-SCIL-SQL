SELECT
*
FROM
APPS.XXAKG_OE_ORDER_DO_MOVE_V ODM
WHERE 1=1
AND ODM.DO_NUMBER='DO/SCOU/1049694'
AND ORG_ID=85
--AND ROWNUM<=7


SELECT ORD.ORG_ID,
            REGION_NAME,
            H.CUSTOMER_NUMBER,
            H.CUSTOMER_NAME,
            ORD.ORDER_NUMBER,
            TRUNC (ORD.ORDERED_DATE) ORDERED_DATE,
            H.DO_NUMBER,
            TRUNC (DO_DATE) DO_DATE,
            MVH.MOV_ORDER_NO,
            APPS.XXAKG_BI_ONT_PKG.GET_BOOKED_QTY (ORD.SOLD_TO_ORG_ID,
                                             ORD.ORG_ID,
                                             ORD.HEADER_ID)
               BOOKED_QTY,
            UOM_CODE,
            NVL (
               SUM (DECODE (H.DO_STATUS, 'GENERATED', NVL (LINE_QUANTITY, 0))),
               0)
               DO_GENERATED_QTY,
            NVL (
               SUM (DECODE (H.DO_STATUS, 'CONFIRMED', NVL (LINE_QUANTITY, 0))),
               0)
               DO_CONFIRMED_QTY,
            NVL (
               SUM(DECODE (MVH.MOV_ORDER_STATUS,
                           'GENERATED', NVL (LINE_QUANTITY, 0))),
               0)
               MOVE_GENERATED_QTY,
            NVL (
               SUM(DECODE (MVH.MOV_ORDER_STATUS,
                           'CONFIRMED', NVL (LINE_QUANTITY, 0))),
               0)
               MOVE_CONFIRMED_QTY,
            NVL (
               APPS.XXAKG_BI_AR_PKG.GET_CUS_AR_QTY (ORD.ORG_ID,
                                               ORD.HEADER_ID,
                                               L.ORDER_LINE_ID),
               0)
               INVOICED_QTY
       FROM APPS.XXAKG_DEL_ORD_HDR H,
            APPS.XXAKG_DEL_ORD_DO_LINES L,
            APPS.OE_ORDER_HEADERS_ALL ORD,
--            APPS.OE_ORDER_LINES_ALL OOL,
            APPS.XXAKG_MOV_ORD_HDR MVH,
            APPS.XXAKG_MOV_ORD_DTL MVD,
            APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM
      WHERE     H.DO_HDR_ID = L.DO_HDR_ID
            AND H.ORG_ID = L.ORG_ID
            AND L.ITEM_NUMBER NOT IN ('EBAG.SBAG.0001', 'EBAG.PBAG.0001')
            AND H.ORG_ID = ORD.ORG_ID
            AND L.ORDER_HEADER_ID = ORD.HEADER_ID
            AND H.DO_HDR_ID = MVD.DO_HDR_ID(+)
            AND MVH.MOV_ORD_HDR_ID(+) = MVD.MOV_ORD_HDR_ID
            AND DBM.CUSTOMER_ID = ORD.SOLD_TO_ORG_ID
            AND DBM.ORG_ID = ORD.ORG_ID
            AND ORD.ORG_ID = 85
--            AND H.DO_NUMBER='DO/SCOU/1049694'
            AND ORD.ORDER_NUMBER='1653068'
   GROUP BY ord.sold_to_org_id,
            REGION_NAME,
            H.CUSTOMER_NUMBER,
            H.CUSTOMER_NAME,
            H.DO_NUMBER,
            ORD.SOLD_TO_ORG_ID,
            ORD.ORG_ID,
            ORD.HEADER_ID,
            ORD.ORDER_NUMBER,
            UOM_CODE,
            TRUNC (DO_DATE),
            TRUNC (ord.ordered_date),
            L.ORDER_LINE_ID,
            MVH.MOV_ORDER_NO