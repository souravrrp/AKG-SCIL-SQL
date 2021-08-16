 SELECT  CUST_NAME_ADDRESS,
   TO_NUMBER,
   TO_DATE,
   ITEM_DESCRIPTION,
   TO_QTY,
   TO_QTY_MTN,
   EMPTY_BAG,
   MODE_OF_TRANSPORT,
   VAT_CHALLAN_NO,
   VAT_CHALLAN_DATE,
   GATE_PASS_NO,
   VEHICLE_NO,
   DRIVER_NAME,
   MOV_ORDER_NO,
   SHIP_TO
   FROM  XXAKG_ONT_CMNT_TO_CLN_V
   WHERE ORG_ID = :P_ORG_ID
   AND TO_number BETWEEN NVL (:P_TO_FROM, To_number)
                          AND NVL (:P_TO_TO,To_number)
   AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)
   AND TO_DATE BETWEEN NVL(:P_DATE_FROM, TO_DATE) AND NVL(:P_DATE_TO, TO_DATE)
   ORDER BY MOV_ORDER_NO
   
   
  ------------------------------------***-----------------------------------------------------
  
  SELECT TH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (TH.CUSTOMER_ID,
                                                        TH.ORG_ID)
               CUST_NAME_ADDRESS,
            TH.TO_NUMBER,
            TRUNC (TH.TO_DATE) TO_DATE,
            Tl.ITEM_DESCRIPTION,
            NVL (SUM (NVL (Tl.QUANTITY, 0)), 0) To_qty,
            SUM ( (NVL (Tl.QUANTITY, 0) * 50) / 1000) TO_QTY_MTN,
            XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_TO (TH.TO_NUMBER, TH.ORG_ID)
               EMPTY_BAG,
            MODE_OF_TRANSPORT,
            mTl.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE) vat_challan_date,
            GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO,
            tl.TO_INV || '-' || OOD.ORGANIZATION_NAME SHIP_TO
       FROM XXAKG_TO_DO_HDR th,
            XXAKG_TO_DO_LINES tl,
            XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
            XXAKG_TO_MO_HDR mth,
            XXAKG_TO_MO_DTL mtl,
            ORG_ORGANIZATION_DEFINITIONS OOD
      WHERE     TH.TO_HDR_ID = TL.TO_HDR_ID
            AND CUST_SITE.CUSTOMER_ID = TH.CUSTOMER_ID
            AND CUST_SITE.ORG_ID = TH.ORG_ID
            AND TH.TO_STATUS = 'CONFIRMED'
            --   AND DH.ORG_ID = :P_ORG_ID
            AND cust_site.SITE_USE_CODE = 'BILL_TO'
            AND CUST_SITE.PRIMARY_FLAG = 'Y'
            AND mth.MOV_ORD_HDR_ID = mtl.MOV_ORD_HDR_ID
            AND mtl.TO_HDR_ID = Th.TO_HDR_ID
            AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
            AND TL.TO_ORGANIZATION_ID = OOD.ORGANIZATION_ID
   ---AND mth.mov_order_no BETWEEN NVL (:P_MOV_FROM,mth.mov_order_no)
   ---  AND NVL (:P_MOV_TO, mth.mov_order_no)
   GROUP BY TH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (TH.CUSTOMER_ID,
                                                        TH.ORG_ID),
            tH.TO_NUMBER,
            TRUNC (tH.TO_DATE),
            tl.ITEM_DESCRIPTION,
            MODE_OF_TRANSPORT,
            mtl.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE),
            GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO,
            tl.TO_INV || '-' || OOD.ORGANIZATION_NAME;
  