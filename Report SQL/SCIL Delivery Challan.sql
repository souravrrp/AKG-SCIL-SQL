  SELECT  CUST_NAME_ADDRESS,
   RETAILER_SHIP_TO,
   DO_NUMBER,
   DO_DATE,
   ITEM_DESCRIPTION,
   CASE when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then null else DO_QTY   end  DO_QTY,
   DO_QTY_MTN,
   EMPTY_BAG,
   MODE_OF_TRANSPORT,
   VAT_CHALLAN_NO,
   VAT_CHALLAN_DATE,
   GATE_PASS_NO,
   VEHICLE_NO,
   DRIVER_NAME,
   MOV_ORDER_NO
   FROM  XXAKG_ONT_CMNT_DELIVERY_CLN_V
   WHERE ORG_ID = :P_ORG_ID
   AND do_number BETWEEN NVL (:P_DO_FROM, do_number)
                          AND NVL (:P_DO_TO,do_number)
   AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)
   AND DO_DATE BETWEEN NVL(:P_DATE_FROM, DO_DATE) AND NVL(:P_DATE_TO, DO_DATE)
   
   
---------------------------------------------------------------------------------------------------------


    SELECT DH.ORG_ID,
            CUSTOMER_ID,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID, DH.ORG_ID) ---TRIM (TRAILING ',' FROM TRIM (TRAILING ' ' FROM CUST_SITE.ADDRESS1
               --- || ', '
               ---     || CUST_SITE.ADDRESS2))
               CUST_NAME_ADDRESS,
            dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO,            -----Iqbal
            DH.DO_NUMBER,
            TRUNC (DH.DO_DATE) DO_DATE,
            dl.ITEM_DESCRIPTION,
            NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0) do_qty,
            CASE
               WHEN UPPER (dl.ITEM_DESCRIPTION) LIKE '%BULK%'
               THEN
                  NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0)
               ELSE
                  SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000)
            END
               DO_QTY_MTN,
            --            SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000) DO_QTY_MTN,
            XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
               EMPTY_BAG,
            MODE_OF_TRANSPORT,
            ml.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE) vat_challan_date,
            NVL(ml.CHALLAN_NO,mh.GATE_PASS_NO) GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO
       FROM XXAKG_DEL_ORD_HDR dh,
            XXAKG_DEL_ORD_DO_LINES DL,
            XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
            XXAKG_MOV_ORD_HDR mh,
            XXAKG_MOV_ORD_DTL ml
      WHERE     DH.DO_HDR_ID = DL.DO_HDR_ID
            AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
            AND CUST_SITE.ORG_ID = DH.ORG_ID
            AND DH.DO_STATUS = 'CONFIRMED'
            --   AND DH.ORG_ID = :P_ORG_ID
            AND cust_site.SITE_USE_CODE = 'BILL_TO'
            AND CUST_SITE.PRIMARY_FLAG = 'Y'
            AND mh.MOV_ORD_HDR_ID = ml.MOV_ORD_HDR_ID
            AND ml.DO_HDR_ID = dh.DO_HDR_ID
            AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
   --AND dh.do_number BETWEEN NVL (:P_DO_FROM, dh.do_number)
   --   AND NVL (:P_DO_TO, dh.do_number)
   GROUP BY DH.ORG_ID,
            CUSTOMER_ID,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID,
                                                        DH.ORG_ID),
            dl.ACTUAL_RETAILER_SHIP_TO,
            DH.DO_NUMBER,
            TRUNC (DH.DO_DATE),
            dl.ITEM_DESCRIPTION,
            MODE_OF_TRANSPORT,
            ml.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE),
            GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO,
            ml.CHALLAN_NO;
            
            
            
--------------------------*************-------------------------------------------------

SELECT DH.ORG_ID,
CUSTOMER_ID,
CUST_SITE.CUSTOMER_NAME
|| ' ('
|| CUST_SITE.CUSTOMER_NUMBER
|| '), '
|| xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID, DH.ORG_ID) ---TRIM (TRAILING ',' FROM TRIM (TRAILING ' ' FROM CUST_SITE.ADDRESS1
--- || ', '
--- || CUST_SITE.ADDRESS2))
CUST_NAME_ADDRESS,
dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO, -----Iqbal
DH.DO_NUMBER,
TRUNC (DH.DO_DATE) DO_DATE,
dl.ITEM_DESCRIPTION,
NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0) do_qty,
/* --add dt20181204 -commented
CASE
WHEN UPPER (dl.ITEM_DESCRIPTION) LIKE '%BULK%'
THEN
NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0)
ELSE
SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000)
END 
DO_QTY_MTN,
*/ --add dt20181204 -commented
DECODE(INV_CONVERT.inv_um_convert(dl.ordered_item_id,5,SUM(dl.line_quantity),dl.uom_code,'MTN',NULL,NULL) --add dt20181204
,-99999,NULL,INV_CONVERT.inv_um_convert(dl.ordered_item_id,5,SUM(dl.line_quantity),dl.uom_code,'MTN',NULL,NULL)) DO_QTY_MTN, --add dt20181204
-- SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000) DO_QTY_MTN,
XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
EMPTY_BAG,
MODE_OF_TRANSPORT,
ml.VAT_CHALLAN_NO,
TRUNC (VAT_RECEIVED_DATE) vat_challan_date,
NVL(ml.CHALLAN_NO,mh.GATE_PASS_NO) GATE_PASS_NO,
VEHICLE_NO,
DRIVER_NAME,
MOV_ORDER_NO
FROM XXAKG_DEL_ORD_HDR dh,
XXAKG_DEL_ORD_DO_LINES DL,
XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
XXAKG_MOV_ORD_HDR mh,
XXAKG_MOV_ORD_DTL ml
WHERE DH.DO_HDR_ID = DL.DO_HDR_ID
AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
AND CUST_SITE.ORG_ID = DH.ORG_ID
AND DH.DO_STATUS = 'CONFIRMED'
-- AND DH.ORG_ID = :P_ORG_ID
AND cust_site.SITE_USE_CODE = 'BILL_TO'
AND CUST_SITE.PRIMARY_FLAG = 'Y'
AND mh.MOV_ORD_HDR_ID = ml.MOV_ORD_HDR_ID
AND ml.DO_HDR_ID = dh.DO_HDR_ID
AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
--AND dh.do_number BETWEEN NVL (:P_DO_FROM, dh.do_number)
-- AND NVL (:P_DO_TO, dh.do_number)
GROUP BY DH.ORG_ID,
CUSTOMER_ID,
CUST_SITE.CUSTOMER_NAME
|| ' ('
|| CUST_SITE.CUSTOMER_NUMBER
|| '), '
|| xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID,
DH.ORG_ID),
dl.ACTUAL_RETAILER_SHIP_TO,
DH.DO_NUMBER,
TRUNC (DH.DO_DATE),
dl.ITEM_DESCRIPTION,
MODE_OF_TRANSPORT,
ml.VAT_CHALLAN_NO,
TRUNC (VAT_RECEIVED_DATE),
GATE_PASS_NO,
VEHICLE_NO,
DRIVER_NAME,
MOV_ORDER_NO,
dl.ordered_item_id, --add dt20181204
dl.uom_code, --add dt20181204
ml.CHALLAN_NO;


------------------------------OLD WITH APPS-----------------------------------------------
SELECT DH.ORG_ID,
            CUSTOMER_ID,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID, DH.ORG_ID) ---TRIM (TRAILING ',' FROM TRIM (TRAILING ' ' FROM CUST_SITE.ADDRESS1
               --- || ', '
               ---     || CUST_SITE.ADDRESS2))
               CUST_NAME_ADDRESS,
            dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO,            -----Iqbal
            DH.DO_NUMBER,
            TRUNC (DH.DO_DATE) DO_DATE,
            dl.ITEM_DESCRIPTION,
            NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0) do_qty,
            CASE
               WHEN UPPER (dl.ITEM_DESCRIPTION) LIKE '%BULK%'
               THEN
                  NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0)
               ELSE
                  SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000)
            END
               DO_QTY_MTN,
            --            SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000) DO_QTY_MTN,
            APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
               EMPTY_BAG,
            MODE_OF_TRANSPORT,
            ml.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE) vat_challan_date,
--            NVL(ml.CHALLAN_NO,mh.GATE_PASS_NO) GATE_PASS_NO,
            mh.GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO
       FROM APPS.XXAKG_DEL_ORD_HDR dh,
            APPS.XXAKG_DEL_ORD_DO_LINES DL,
            APPS.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
            APPS.XXAKG_MOV_ORD_HDR mh,
            APPS.XXAKG_MOV_ORD_DTL ml
      WHERE     DH.DO_HDR_ID = DL.DO_HDR_ID
            AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
            AND CUST_SITE.ORG_ID = DH.ORG_ID
            AND DH.DO_STATUS = 'CONFIRMED'
            --   AND DH.ORG_ID = :P_ORG_ID
            AND cust_site.SITE_USE_CODE = 'BILL_TO'
            AND CUST_SITE.PRIMARY_FLAG = 'Y'
            AND mh.MOV_ORD_HDR_ID = ml.MOV_ORD_HDR_ID
            AND ml.DO_HDR_ID = dh.DO_HDR_ID
            AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
            and dh.do_number='DO/SCOU/1246891'
   --AND dh.do_number BETWEEN NVL (:P_DO_FROM, dh.do_number)
   --   AND NVL (:P_DO_TO, dh.do_number)
   GROUP BY DH.ORG_ID,
            CUSTOMER_ID,
               CUST_SITE.CUSTOMER_NAME
            || ' ('
            || CUST_SITE.CUSTOMER_NUMBER
            || '), '
            || APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID,
                                                        DH.ORG_ID),
            dl.ACTUAL_RETAILER_SHIP_TO,
            DH.DO_NUMBER,
            TRUNC (DH.DO_DATE),
            dl.ITEM_DESCRIPTION,
            MODE_OF_TRANSPORT,
            ml.VAT_CHALLAN_NO,
            TRUNC (VAT_RECEIVED_DATE),
            GATE_PASS_NO,
            VEHICLE_NO,
            DRIVER_NAME,
            MOV_ORDER_NO
--            ,ml.CHALLAN_NO;

-------------------------------------------New Added in APPS------------------------------

SELECT DH.ORG_ID,
CUSTOMER_ID,
CUST_SITE.CUSTOMER_NAME
|| ' ('
|| CUST_SITE.CUSTOMER_NUMBER
|| '), '
|| apps.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID, DH.ORG_ID) ---TRIM (TRAILING ',' FROM TRIM (TRAILING ' ' FROM CUST_SITE.ADDRESS1
--- || ', '
--- || CUST_SITE.ADDRESS2))
CUST_NAME_ADDRESS,
dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO, -----Iqbal
DH.DO_NUMBER,
TRUNC (DH.DO_DATE) DO_DATE,
dl.ITEM_DESCRIPTION,
NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0) do_qty,
/* --add dt20181204 -commented
CASE
WHEN UPPER (dl.ITEM_DESCRIPTION) LIKE '%BULK%'
THEN
NVL (SUM (NVL (dl.LINE_QUANTITY, 0)), 0)
ELSE
SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000)
END 
DO_QTY_MTN,
*/ --add dt20181204 -commented
DECODE(apps.INV_CONVERT.inv_um_convert(dl.ordered_item_id,5,SUM(dl.line_quantity),dl.uom_code,'MTN',NULL,NULL) --add dt20181204
,-99999,NULL,apps.INV_CONVERT.inv_um_convert(dl.ordered_item_id,5,SUM(dl.line_quantity),dl.uom_code,'MTN',NULL,NULL)) DO_QTY_MTN, --add dt20181204
-- SUM ( (NVL (dl.LINE_QUANTITY, 0) * 50) / 1000) DO_QTY_MTN,
apps.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
EMPTY_BAG,
MODE_OF_TRANSPORT,
ml.VAT_CHALLAN_NO,
TRUNC (VAT_RECEIVED_DATE) vat_challan_date,
--NVL(ml.CHALLAN_NO,mh.GATE_PASS_NO) GATE_PASS_NO,
mh.GATE_PASS_NO,
VEHICLE_NO,
DRIVER_NAME,
MOV_ORDER_NO
FROM apps.XXAKG_DEL_ORD_HDR dh,
apps.XXAKG_DEL_ORD_DO_LINES DL,
apps.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
apps.XXAKG_MOV_ORD_HDR mh,
apps.XXAKG_MOV_ORD_DTL ml
WHERE DH.DO_HDR_ID = DL.DO_HDR_ID
AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
AND CUST_SITE.ORG_ID = DH.ORG_ID
AND DH.DO_STATUS = 'CONFIRMED'
-- AND DH.ORG_ID = :P_ORG_ID
AND cust_site.SITE_USE_CODE = 'BILL_TO'
AND CUST_SITE.PRIMARY_FLAG = 'Y'
AND mh.MOV_ORD_HDR_ID = ml.MOV_ORD_HDR_ID
AND ml.DO_HDR_ID = dh.DO_HDR_ID
AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
and dh.do_number='DO/SCOU/1246891'
--AND dh.do_number BETWEEN NVL (:P_DO_FROM, dh.do_number)
-- AND NVL (:P_DO_TO, dh.do_number)
GROUP BY DH.ORG_ID,
CUSTOMER_ID,
CUST_SITE.CUSTOMER_NAME
|| ' ('
|| CUST_SITE.CUSTOMER_NUMBER
|| '), '
|| apps.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUSTOMER_ID,
DH.ORG_ID),
dl.ACTUAL_RETAILER_SHIP_TO,
DH.DO_NUMBER,
TRUNC (DH.DO_DATE),
dl.ITEM_DESCRIPTION,
MODE_OF_TRANSPORT,
ml.VAT_CHALLAN_NO,
TRUNC (VAT_RECEIVED_DATE),
GATE_PASS_NO,
VEHICLE_NO,
DRIVER_NAME,
MOV_ORDER_NO,
dl.ordered_item_id, --add dt20181204
dl.uom_code --add dt20181204
--,ml.CHALLAN_NO;
