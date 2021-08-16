SELECT NVL (R.REGION_NAME, 'Not Defined') REGION_NAME,
         H.CUSTOMER_NUMBER,
         H.CUSTOMER_NAME,
         ORD.ORDER_NUMBER,
         XXAKG_ONT_PKG.GET_UNIT_PRICE(L.PRICE_LIST_ID, L.ITEM_NUMBER,TRUNC(ORD.ORDERED_DATE)) UNIT_PRICE,
         H.DO_NUMBER,
         TRUNC (H.DO_DATE) DO_DATE,
         L.ITEM_NUMBER,
         DECODE (H.READY_FOR_PRINTING, 'Y', 'Yes', 'No') READY_FOR_PRINTING,
         INITCAP (DECODE (:P_DO_STATUS, 'CONFIRMED', MVH.MOV_ORDER_STATUS,H.DO_STATUS))  STAUS,
         L.ITEM_DESCRIPTION,
         DECODE (L.WAREHOUSE_ORG_ID,
                 101, L.WAREHOUSE_ORG_CODE,
                 XXAKG_COM_PKG.GET_ORGANIZATION_NAME (L.WAREHOUSE_ORG_ID))WAREHOUSE,
         MODE_OF_TRANSPORT,
         NVL (L.ACTUAL_RETAILER_SHIP_TO,XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION(L.SHIP_TO_ORG_ID))DELIVERY_LOCATION,
         MOV_ORDER_NO, VEHICLE_NO,
         SUM (LINE_QUANTITY) DO_QUANTITY
    FROM XXAKG_DEL_ORD_HDR H,
         XXAKG_DEL_ORD_DO_LINES L,
         FND_LOOKUP_VALUES LOOKUP,
         XXAKG_DISTRIBUTOR_BLOCK_M R,
         OE_ORDER_HEADERS_ALL ORD,
         XXAKG_MOV_ORD_HDR MVH,
         XXAKG_MOV_ORD_DTL MVD,
         XXAKG_AR_CUSTOMER_SITE_V CUST
   WHERE H.DO_HDR_ID = L.DO_HDR_ID
         AND H.ORG_ID = L.ORG_ID
         AND L.ITEM_NUMBER NOT IN ('EBAG.SBAG.0001', 'EBAG.PBAG.0001','EBAG.SBAG.0002','EBAG.PBAG.0002')
         AND H.ORG_ID = :P_ORG_ID
         AND H.DO_NUMBER = LOOKUP.LOOKUP_CODE(+)
         AND H.CUSTOMER_NUMBER = R.CUSTOMER_NUMBER(+)
         AND L.ORDER_HEADER_ID = ORD.HEADER_ID
         AND H.DO_HDR_ID = MVD.DO_HDR_ID (+)
         AND MVH.MOV_ORD_HDR_ID (+) = MVD.MOV_ORD_HDR_ID
         AND H.CUSTOMER_NUMBER = CUST.CUSTOMER_NUMBER
         AND H.ORG_ID = CUST.ORG_ID
         --AND CUST.SHIP_TO_ORG_ID = L.SHIP_TO_ORG_ID-------------Modified by nazrul dated on 28/aug/2011
         and CUST.SITE_USE_CODE='BILL_TO'
         AND CUST.PRIMARY_FLAG='Y'
         AND (:P_CUSTOMER_STATUS IS NULL OR (CUST.STATUS =:P_CUSTOMER_STATUS))
         AND (:P_DO_ID IS NULL OR (H.DO_HDR_ID = :P_DO_ID))
         AND DECODE (:P_DO_STATUS, 'CANCELLED', 'XXXXX', H.DO_STATUS) <> 'CANCELLED'
         AND TRUNC(ORD.ORDERED_DATE) BETWEEN :P_ORDER_DATE_FROM AND :P_ORDER_DATE_TO
         AND (:P_DATE_FROM IS NULL OR (DECODE (:P_DO_STATUS,
                     'CONFIRMED', TRUNC (LOOKUP.START_DATE_ACTIVE),
                     'CANCELLED', TRUNC (CANCELLED_DATE),
                     TRUNC (h.DO_DATE)) BETWEEN :P_DATE_FROM
                                            AND :P_DATE_TO))
        AND (:P_CUSTOMER_NUMBER IS NULL
              OR (H.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
        AND (:P_DO_STATUS IS NULL OR (DECODE (:P_DO_STATUS, 'CONFIRMED', MVH.MOV_ORDER_STATUS, DO_STATUS) = :P_DO_STATUS))
         AND (:P_WAREHOUSE IS NULL OR (L.WAREHOUSE_ORG_ID = :P_WAREHOUSE))
         AND (:P_READY_FOR_PRINTING IS NULL
              OR (NVL (H.READY_FOR_PRINTING, 'N') =
                     SUBSTR (:P_READY_FOR_PRINTING, 1, 1)))
         AND (:P_TRANS_FOR_LOAD IS NULL
              OR (NVL (MVD.TRANSFER_LOADING_FLAG, 'N') =
                     SUBSTR (:P_TRANS_FOR_LOAD, 1, 1)))
         AND (:P_TRUCK_LOADED IS NULL
              OR (NVL (MVD.TRUCK_LOADING_FLAG, 'N') =
                     SUBSTR (:P_TRUCK_LOADED, 1, 1)))
         AND (:P_REGION_NAME IS NULL OR (R.REGION_NAME = :P_REGION_NAME))
         AND (:P_MODE_OF_TRANSPORT IS NULL OR
(UPPER(NVL(H.MODE_OF_TRANSPORT,'XX')) = UPPER(:P_MODE_OF_TRANSPORT)))
         AND EXISTS
                (SELECT 1
                   FROM APPS.FND_LOOKUP_VALUES b
                  WHERE     b.lookup_type = 'CEMENT_COMPANY_REGION_USER'
                        AND R.REGION_NAME = b.attribute13
                        and b.attribute9=:P_COMPANY AND b.attribute6 = :P_person_id
                        and b.ATTRIBUTE_CATEGORY='SCIL O2C Region'
                        and h.org_id=85
                   union
                   select 1 from dual where h.org_id <>85
                        )
         AND EXISTS
                (SELECT 1
                   FROM apps.ORG_ACCESs d
                  WHERE d.responsibility_id = :P_RESPONSIBILITY_ID
                        AND D.ORGANIZATION_ID = L.WAREHOUSE_ORG_ID
                        and h.org_id=85
                    union
                    select 1 from dual where h.org_id<>85
                        )
        &P_MOVE_ORDER_WHERE
GROUP BY R.REGION_NAME,
         H.CUSTOMER_NUMBER,
         H.CUSTOMER_NAME,
         ORD.ORDER_NUMBER,
         H.DO_NUMBER,
         TRUNC (H.DO_DATE),
         L.ITEM_NUMBER,
         MVH.MOV_ORDER_STATUS,
         H.DO_STATUS,
         DECODE (H.READY_FOR_PRINTING, 'Y', 'Yes', 'No'),
         L.ITEM_DESCRIPTION,
         L.WAREHOUSE_ORG_ID,
         L.WAREHOUSE_ORG_CODE,
         MODE_OF_TRANSPORT,
         NVL (L.ACTUAL_RETAILER_SHIP_TO, XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION(L.SHIP_TO_ORG_ID)),
         L.PRICE_LIST_ID,
         ORD.ORDERED_DATE,
         MOV_ORDER_NO,
         VEHICLE_NO
ORDER BY TRUNC (DO_DATE), H.DO_NUMBER, L.ITEM_NUMBER