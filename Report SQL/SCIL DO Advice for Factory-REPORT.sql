SELECT customer_id,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   DO_NUMBER,
   FINAL_DESTINATION,
   DO_DATE,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') then 'Bulk Cement'
  else FREE_TEXT   end   FREE_TEXT ,
   ITEM_DESCRIPTION,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') then null
  else DO_QTY   end   DO_QTY ,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') then  DO_QTY
  else  ((DO_QTY*50)/1000)  end   MT_DO_QTY ,
   SHIP_FROM,
   --SHIP_TO,
   CASE WHEN RETAILER_SHIP_TO IS NOT NULL THEN RETAILER_SHIP_TO  || '=' || NVL (DO_QTY, 0) ELSE SHIP_TO END SHIP_TO,
--   RETAILER_SHIP_TO,
   EMPTY_BAG,
   MODE_OF_TRANSPORT
FROM apps.XXAKG_OE_CEMENT_DO_ADV_FA_V
WHERE ORG_ID=:P_ORG_ID
AND do_number between NVL(:P_DO_FROM,do_number) AND NVL(:P_DO_TO,do_number)
and trunc(DO_DATE) between nvl(:p_date_from,trunc(DO_DATE)) and nvl(:p_date_to,trunc(DO_DATE))
AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)
AND    MODE_OF_TRANSPORT=NVL(:P_MODE_OF_TRANSPORT,MODE_OF_TRANSPORT)


SELECT customer_id,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   do.DO_NUMBER,
   FINAL_DESTINATION,
   DO_DATE,
   CASE 
  when  do.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then 'Bulk Cement'
  else FREE_TEXT   end   FREE_TEXT ,
   do.ITEM_DESCRIPTION,
   CASE 
  when  do.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then null
  else DO_QTY   end   DO_QTY ,
   CASE 
  when  do.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then  DO_QTY
  else  ((DO_QTY*50)/1000)  end   MT_DO_QTY ,
   SHIP_FROM,
   NVL (dodl.ACTUAL_RETAILER_SHIP_TO,apps.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION(dodl.SHIP_TO_ORG_ID))DELIVERY_LOCATION,
   SHIP_TO,
   RETAILER_SHIP_TO,
   EMPTY_BAG,
   MODE_OF_TRANSPORT
FROM apps.XXAKG_OE_CEMENT_DO_ADV_FA_V do
,apps.XXAKG_DEL_ORD_DO_LINES dodl
WHERE 1=1
and dodl.do_number=do.do_number
and do.ORG_ID=:P_ORG_ID
--AND do.do_number between NVL(:P_DO_FROM,do.do_number) AND NVL(:P_DO_TO,do.do_number)
--and trunc(DO_DATE) between nvl(:p_date_from,trunc(DO_DATE)) and nvl(:p_date_to,trunc(DO_DATE))
--AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)
--AND    MODE_OF_TRANSPORT=NVL(:P_MODE_OF_TRANSPORT,MODE_OF_TRANSPORT)


-------------------------------

SELECT --DOH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
   APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUST_SITE.CUSTOMER_ID,
                                                     DOH.ORG_ID) ADDRESS,
   DOH.DO_NUMBER,
   DOH.FINAL_DESTINATION,
   DOH.DO_DATE,
   CASE 
   WHEN SUBSTR(DODL.ITEM_NUMBER,1,4)='CMNT' AND DODL.UOM_CODE='MTN'--AND SUBSTR(DODL.ITEM_NUMBER,7,3)='BLK' -- DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') 
   THEN 'Bulk Cement'
   ELSE 'Packed Cement'   END   FREE_TEXT ,
   DODL.ITEM_DESCRIPTION,
   CASE 
   WHEN SUBSTR(DODL.ITEM_NUMBER,1,4)='CMNT' AND DODL.UOM_CODE='MTN'-- AND SUBSTR(DODL.ITEM_NUMBER,7,3)='BLK'-- DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') 
   THEN NULL
   ELSE SUM (NVL (DODL.LINE_QUANTITY, 0))   END   DO_QTY ,
   CASE 
   WHEN SUBSTR(DODL.ITEM_NUMBER,1,4)='CMNT' AND DODL.UOM_CODE='MTN'--AND SUBSTR(DODL.ITEM_NUMBER,7,3)='BLK'-- DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)','BULK Cement (CEM-3)') 
   then  SUM (NVL (DODL.LINE_QUANTITY, 0))
   ELSE  ((SUM (NVL (DODL.LINE_QUANTITY, 0))*50)/1000)  END   MT_DO_QTY ,
   OOD.ORGANIZATION_NAME SHIP_FROM,
--   SHIP_TO,
--   RETAILER_SHIP_TO,
(CASE 
          WHEN  DODL.ACTUAL_RETAILER_SHIP_TO IS NOT NULL  THEN DODL.ACTUAL_RETAILER_SHIP_TO || '=' || SUM (NVL (DODL.LINE_QUANTITY, 0))
            ELSE CUST_SITE.location
            || ', '
            || CUST_SITE.location_address
            || '='
            || SUM (NVL (DODL.LINE_QUANTITY, 0))
END) SHIP_TO,
   APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DOH.DO_NUMBER, DOH.ORG_ID) EMPTY_BAG,
   DOH.MODE_OF_TRANSPORT
FROM APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
,APPS.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND DODL.WAREHOUSE_ORG_ID = OOD.ORGANIZATION_ID
AND DOH.DO_HDR_ID = DODL.DO_HDR_ID
AND CUST_SITE.CUSTOMER_NUMBER = DOH.CUSTOMER_NUMBER
AND DODL.SHIP_TO_ORG_ID=CUST_SITE.SHIP_TO_ORG_ID
AND CUST_SITE.ORG_ID = DOH.ORG_ID
AND DOH.DO_STATUS = 'GENERATED'
AND OOD.ORGANIZATION_CODE = 'SCI'
AND CUST_SITE.SITE_USE_CODE = 'SHIP_TO'
AND DOH.READY_FOR_PRINTING = 'Y'
AND NVL (DOH.PRINTED_FLAG, 'N') = 'N'
AND SUBSTR (ITEM_NUMBER, 1, 4) <> 'SCRP'
AND DODL.ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001','EBAG.OBAG.0001','EBAG.CBAG.0001')
AND DOH.ORG_ID=:P_ORG_ID
AND DOH.DO_NUMBER BETWEEN NVL(:P_DO_FROM,DOH.DO_NUMBER) AND NVL(:P_DO_TO,DOH.DO_NUMBER)
AND TRUNC(DOH.DO_DATE) BETWEEN NVL(:P_DATE_FROM,trunc(DOH.DO_DATE)) AND NVL(:P_DATE_TO,TRUNC(DOH.DO_DATE))
AND CUST_SITE.CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUST_SITE.CUSTOMER_ID)
AND DOH.MODE_OF_TRANSPORT=NVL(:P_MODE_OF_TRANSPORT,DOH.MODE_OF_TRANSPORT)
GROUP BY
DOH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            DOH.DO_NUMBER,
   DOH.FINAL_DESTINATION,
   DOH.DO_DATE
   ,DODL.ITEM_DESCRIPTION
   ,OOD.ORGANIZATION_NAME 
   ,DODL.ACTUAL_RETAILER_SHIP_TO
   ,CUST_SITE.LOCATION,CUST_SITE.location_address
   ,DOH.MODE_OF_TRANSPORT
   ,DODL.ITEM_NUMBER
   ,DODL.UOM_CODE


------------------------------------------------------------------------------------------------

SELECT --DOH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
   APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUST_SITE.CUSTOMER_ID,
                                                     DOH.ORG_ID) ADDRESS,
   DOH.DO_NUMBER,
   DOH.FINAL_DESTINATION,
   DOH.DO_DATE,
   CASE 
   WHEN  DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') THEN 'Bulk Cement'
   ELSE 'Packed Cement'   END   FREE_TEXT ,
   DODL.ITEM_DESCRIPTION,
   CASE 
   WHEN  DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') THEN NULL
   ELSE SUM (NVL (DODL.LINE_QUANTITY, 0))   END   DO_QTY ,
   CASE 
   WHEN  DODL.ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then  SUM (NVL (DODL.LINE_QUANTITY, 0))
   ELSE  ((SUM (NVL (DODL.LINE_QUANTITY, 0))*50)/1000)  END   MT_DO_QTY ,
   OOD.ORGANIZATION_NAME SHIP_FROM,
--   SHIP_TO,
--   RETAILER_SHIP_TO,
(CASE 
          WHEN  DODL.ACTUAL_RETAILER_SHIP_TO IS NOT NULL  THEN DODL.ACTUAL_RETAILER_SHIP_TO || '=' || SUM (NVL (DODL.LINE_QUANTITY, 0))
            ELSE CUST_SITE.location
            || ', '
            || CUST_SITE.location_address
            || '='
            || SUM (NVL (DODL.LINE_QUANTITY, 0))
END) SHIP_TO,
   APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DOH.DO_NUMBER, DOH.ORG_ID) EMPTY_BAG,
   DOH.MODE_OF_TRANSPORT
FROM APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
,APPS.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND DODL.WAREHOUSE_ORG_ID = OOD.ORGANIZATION_ID
AND DOH.DO_HDR_ID = DODL.DO_HDR_ID
AND CUST_SITE.CUSTOMER_NUMBER = DOH.CUSTOMER_NUMBER
AND DODL.SHIP_TO_ORG_ID=CUST_SITE.SHIP_TO_ORG_ID
AND CUST_SITE.ORG_ID = DOH.ORG_ID
AND CUST_SITE.SITE_USE_CODE = 'SHIP_TO'
AND DODL.ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
AND DOH.ORG_ID=:P_ORG_ID
AND DOH.DO_NUMBER BETWEEN NVL(:P_DO_FROM,DOH.DO_NUMBER) AND NVL(:P_DO_TO,DOH.DO_NUMBER)
AND TRUNC(DOH.DO_DATE) BETWEEN NVL(:P_DATE_FROM,trunc(DOH.DO_DATE)) AND NVL(:P_DATE_TO,TRUNC(DOH.DO_DATE))
AND CUST_SITE.CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUST_SITE.CUSTOMER_ID)
AND DOH.MODE_OF_TRANSPORT=NVL(:P_MODE_OF_TRANSPORT,DOH.MODE_OF_TRANSPORT)
GROUP BY
DOH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            DOH.DO_NUMBER,
   DOH.FINAL_DESTINATION,
   DOH.DO_DATE
   ,DODL.ITEM_DESCRIPTION
   ,OOD.ORGANIZATION_NAME 
   ,DODL.ACTUAL_RETAILER_SHIP_TO
   ,CUST_SITE.LOCATION,CUST_SITE.location_address
   ,DOH.MODE_OF_TRANSPORT


------------------------------------------------------------------------------


SELECT DH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUST_SITE.CUSTOMER_ID,
                                                     DH.ORG_ID)
               ADDRESS,
            DH.DO_NUMBER,
            DH.FINAL_DESTINATION,
            TRUNC (DH.DO_DATE) DO_DATE,
            'Packed Cement' Free_Text,
            dl.ITEM_DESCRIPTION,
            SUM (NVL (dl.LINE_QUANTITY, 0)) DO_QTY,
            --- SUM ( (dl.LINE_QUANTITY * 50) / 1000) DO_QTY_MTN,
            ORGANIZATION_NAME SHIP_FROM,
            NVL (DL.ACTUAL_RETAILER_SHIP_TO,APPS.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION(DL.SHIP_TO_ORG_ID))
            || '='
            || SUM (NVL (dl.LINE_QUANTITY, 0)) DELIVERY_LOCATION,-----NEW UPDATED
               /*           NVL (dl.ACTUAL_RETAILER_SHIP_TO,
                               CUST_SITE.location || ', ' || CUST_SITE.location_address)
                          || '='
                          || SUM (NVL (dl.LINE_QUANTITY, 0))
                             SHIP_TO, */
               CUST_SITE.location
            || ', '
            || CUST_SITE.location_address
            || '='
            || SUM (NVL (dl.LINE_QUANTITY, 0))
               SHIP_TO,
            dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO,              ---Iqbal
            APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
               EMPTY_BAG,
            MODE_OF_TRANSPORT
       FROM APPS.XXAKG_DEL_ORD_HDR dh,
            APPS.XXAKG_DEL_ORD_DO_LINES DL,
            APPS.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
            APPS.ORG_ORGANIZATION_DEFINITIONS OOD
      WHERE     DH.DO_HDR_ID = DL.DO_HDR_ID
            AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
            AND CUST_SITE.SITE_USE_CODE = 'SHIP_TO'
            AND CUST_SITE.ORG_ID = DH.ORG_ID
            AND DH.DO_STATUS = 'GENERATED'
            -- AND DH.ORG_ID=:P_ORG_ID
            AND DL.WAREHOUSE_ORG_ID = OOD.ORGANIZATION_ID
            AND DH.ORG_ID = OOD.OPERATING_UNIT
            AND cust_site.SHIP_TO_ORG_ID = dl.SHIP_TO_ORG_ID
            AND ood.ORGANIZATION_CODE = 'SCI'
            AND READY_FOR_PRINTING = 'Y'
            AND NVL (PRINTED_FLAG, 'N') = 'N'
            AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
            AND SUBSTR (ITEM_NUMBER, 1, 4) <> 'SCRP'
     and dh.do_number=NVL(:P_DO_NUMBER,dh.do_number)
   GROUP BY DH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            CUST_SITE.location || ', ' || CUST_SITE.location_address,
            DH.DO_NUMBER,
            DH.FINAL_DESTINATION,
            TRUNC (DH.DO_DATE),
            dl.ITEM_DESCRIPTION,
            NVL (dl.LINE_QUANTITY, 0),
            ORGANIZATION_NAME,
            NVL (DL.ACTUAL_RETAILER_SHIP_TO,APPS.XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION(DL.SHIP_TO_ORG_ID)),-----NEW UPDATED
               ---NVL (dl.ACTUAL_RETAILER_SHIP_TO,CUST_SITE.location || ', ' || CUST_SITE.location_address),
               dl.ACTUAL_RETAILER_SHIP_To
            || ','
            || CUST_SITE.location
            || ', '
            || CUST_SITE.location_address,
            dl.ACTUAL_RETAILER_SHIP_TO,
            APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID),
            MODE_OF_TRANSPORT;
            
            
            ---------------------------------------------SCIL DO Advice for Factory---------------------------------
            
            SELECT customer_id,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   DO_NUMBER,
   FINAL_DESTINATION,
   DO_DATE,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then 'Bulk Cement'
  else FREE_TEXT   end   FREE_TEXT ,
   ITEM_DESCRIPTION,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then null
  else DO_QTY   end   DO_QTY ,
   CASE 
  when  ITEM_DESCRIPTION in  ('Ordinary Portland Cement (Bulk)','BULK Cement (Popular)','BULK Cement (Special)') then  DO_QTY
  else  ((DO_QTY*50)/1000)  end   MT_DO_QTY ,
   SHIP_FROM,
   SHIP_TO,
   RETAILER_SHIP_TO,
   EMPTY_BAG,
   MODE_OF_TRANSPORT
FROM apps.XXAKG_OE_CEMENT_DO_ADV_FA_V
WHERE ORG_ID=:P_ORG_ID
AND do_number between NVL(:P_DO_FROM,do_number) AND NVL(:P_DO_TO,do_number)
and trunc(DO_DATE) between nvl(:p_date_from,trunc(DO_DATE)) and nvl(:p_date_to,trunc(DO_DATE))
AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)
AND    MODE_OF_TRANSPORT=NVL(:P_MODE_OF_TRANSPORT,MODE_OF_TRANSPORT)


----------------------------------View Query-------------------------------

SELECT DH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            APPS.xxakg_ont_pkg.GET_CUSTOMER_BILL_TO_SITE (CUST_SITE.CUSTOMER_ID,
                                                     DH.ORG_ID)
               ADDRESS,
            DH.DO_NUMBER,
            DH.FINAL_DESTINATION,
            TRUNC (DH.DO_DATE) DO_DATE,
            'Packed Cement' Free_Text,
            dl.ITEM_DESCRIPTION,
            SUM (NVL (dl.LINE_QUANTITY, 0)) DO_QTY,
            --- SUM ( (dl.LINE_QUANTITY * 50) / 1000) DO_QTY_MTN,
            ORGANIZATION_NAME SHIP_FROM,
               /*           NVL (dl.ACTUAL_RETAILER_SHIP_TO,
                               CUST_SITE.location || ', ' || CUST_SITE.location_address)
                          || '='
                          || SUM (NVL (dl.LINE_QUANTITY, 0))
                             SHIP_TO, */
               CUST_SITE.location
            || ', '
            || CUST_SITE.location_address
            || '='
            || SUM (NVL (dl.LINE_QUANTITY, 0))
               SHIP_TO,
            dl.ACTUAL_RETAILER_SHIP_TO RETAILER_SHIP_TO,              ---Iqbal
            APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID)
               EMPTY_BAG,
            MODE_OF_TRANSPORT
       FROM APPS.XXAKG_DEL_ORD_HDR dh,
            APPS.XXAKG_DEL_ORD_DO_LINES DL,
            APPS.XXAKG_AR_CUSTOMER_SITE_V CUST_SITE,
            APPS.ORG_ORGANIZATION_DEFINITIONS OOD
      WHERE     DH.DO_HDR_ID = DL.DO_HDR_ID
            AND CUST_SITE.CUSTOMER_NUMBER = DH.CUSTOMER_NUMBER
            AND CUST_SITE.SITE_USE_CODE = 'SHIP_TO'
            AND CUST_SITE.ORG_ID = DH.ORG_ID
            AND DH.DO_STATUS = 'GENERATED'
            -- AND DH.ORG_ID=:P_ORG_ID
            AND DL.WAREHOUSE_ORG_ID = OOD.ORGANIZATION_ID
            AND DH.ORG_ID = OOD.OPERATING_UNIT
            AND cust_site.SHIP_TO_ORG_ID = dl.SHIP_TO_ORG_ID
            AND ood.ORGANIZATION_CODE = 'SCI'
            AND READY_FOR_PRINTING = 'Y'
            AND NVL (PRINTED_FLAG, 'N') = 'N'
            AND ITEM_NUMBER NOT IN ('EBAG.PBAG.0001', 'EBAG.SBAG.0001')
            AND SUBSTR (ITEM_NUMBER, 1, 4) <> 'SCRP'
   --  and dh.do_number=NVL(:P_DO_NUMBER,dh.do_number)
   GROUP BY DH.ORG_ID,
            CUST_SITE.CUSTOMER_ID,
            CUST_SITE.CUSTOMER_NUMBER,
            CUST_SITE.CUSTOMER_NAME,
            CUST_SITE.location || ', ' || CUST_SITE.location_address,
            DH.DO_NUMBER,
            DH.FINAL_DESTINATION,
            TRUNC (DH.DO_DATE),
            dl.ITEM_DESCRIPTION,
            NVL (dl.LINE_QUANTITY, 0),
            ORGANIZATION_NAME,
               ---NVL (dl.ACTUAL_RETAILER_SHIP_TO,CUST_SITE.location || ', ' || CUST_SITE.location_address),
               dl.ACTUAL_RETAILER_SHIP_To
            || ','
            || CUST_SITE.location
            || ', '
            || CUST_SITE.location_address,
            dl.ACTUAL_RETAILER_SHIP_TO,
            APPS.XXAKG_ONT_PKG.GET_EMPTY_BAG_FROM_DO (DH.DO_NUMBER, DH.ORG_ID),
            MODE_OF_TRANSPORT;