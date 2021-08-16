SELECT NVL (R.REGION_NAME, 'Not Defined') REGION_NAME,
            DB.BLOCK_NAME,
            H.CUSTOMER_NUMBER,
            H.CUSTOMER_NAME,
            ORD.ORDER_NUMBER,
            APPS.XXAKG_ONT_PKG.GET_UNIT_PRICE (L.PRICE_LIST_ID,
                                          L.ITEM_NUMBER,
                                          TRUNC (ORD.ORDERED_DATE))
               UNIT_PRICE,
            H.DO_NUMBER,
            TRUNC (H.DO_DATE) DO_DATE,
            L.ITEM_NUMBER,
            DECODE (H.READY_FOR_PRINTING, 'Y', 'Yes', 'No') READY_FOR_PRINTING,
            INITCAP (MVH.MOV_ORDER_STATUS) STAUS,
            L.ITEM_DESCRIPTION,
            DECODE (L.WAREHOUSE_ORG_ID,
                    101, L.WAREHOUSE_ORG_CODE,
                    APPS.XXAKG_COM_PKG.GET_ORGANIZATION_NAME (L.WAREHOUSE_ORG_ID))
               WAREHOUSE,
            MODE_OF_TRANSPORT,
            NVL (
               L.ACTUAL_RETAILER_SHIP_TO,
               APPS.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION (L.SHIP_TO_ORG_ID))
               DELIVERY_LOCATION,
            MOV_ORDER_NO,
            mvh.FINAL_DESTINATION,
            VEHICLE_NO,
            SUM (LINE_QUANTITY) DO_QUANTITY
       FROM XXAKG_DEL_ORD_HDR H,
            XXAKG_DEL_ORD_DO_LINES L,
            APPS.FND_LOOKUP_VALUES LOOKUP,
            APPS.XXAKG_DISTRIBUTOR_BLOCK_M R,
            APPS.XXAKG_DISTRIBUTOR_BLOCK_D DB,
            APPS.OE_ORDER_HEADERS_ALL ORD,
            APPS.XXAKG_MOV_ORD_HDR MVH,
            APPS.XXAKG_MOV_ORD_DTL MVD,
            APPS.XXAKG_AR_CUSTOMER_SITE_V CUST
      WHERE     H.DO_HDR_ID = L.DO_HDR_ID
            AND H.ORG_ID = L.ORG_ID
            AND H.ORG_ID = 85
            AND H.DO_NUMBER = LOOKUP.LOOKUP_CODE(+)
            AND H.CUSTOMER_NUMBER = R.CUSTOMER_NUMBER(+)
            AND L.ORDER_HEADER_ID = ORD.HEADER_ID
            AND R.HEADER_ID=DB.HEADER_ID
            AND H.DO_HDR_ID = MVD.DO_HDR_ID(+)
            AND MVH.MOV_ORD_HDR_ID(+) = MVD.MOV_ORD_HDR_ID
            AND H.CUSTOMER_NUMBER = CUST.CUSTOMER_NUMBER
            AND H.ORG_ID = CUST.ORG_ID
            --AND CUST.SHIP_TO_ORG_ID = L.SHIP_TO_ORG_ID-------------Modified by nazrul dated on 28/aug/2011
            AND CUST.SITE_USE_CODE = 'BILL_TO'
            AND CUST.PRIMARY_FLAG = 'Y'
            --         AND CUST.STATUS = 'A'
            AND H.DO_STATUS <> 'CANCELLED'
--            AND TRUNC (h.DO_DATE) BETWEEN '01-AUG-2011' AND '31-AUG-2011'
            --AND ORD.ORDER_NUMBER
            AND H.DO_NUMBER='DO/SCOU/1013764'
--            AND MOV_ORDER_NO='MO/SCOU/1013727'
   GROUP BY R.REGION_NAME,
            DB.BLOCK_NAME,
            H.CUSTOMER_NUMBER,
            H.CUSTOMER_NAME,
            ORD.ORDER_NUMBER,
            H.DO_NUMBER,
            TRUNC (H.DO_DATE),
            L.ITEM_NUMBER,
            MVH.MOV_ORDER_STATUS,
            DECODE (H.READY_FOR_PRINTING, 'Y', 'Yes', 'No'),
            L.ITEM_DESCRIPTION,
            L.WAREHOUSE_ORG_ID,
            L.WAREHOUSE_ORG_CODE,
            MODE_OF_TRANSPORT,
            NVL (
               L.ACTUAL_RETAILER_SHIP_TO,
               APPS.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION (
                  L.SHIP_TO_ORG_ID)),
            L.PRICE_LIST_ID,
            ORD.ORDERED_DATE,
            MOV_ORDER_NO,
            mvh.FINAL_DESTINATION,
            VEHICLE_NO
      ORDER BY TRUNC (DO_DATE), H.DO_NUMBER