SELECT
*
FROM
APPS.XXAKG_SCIL_ORDER_SMS_V
WHERE ROWNUM<=3


XXAKG_OE_DO2MOVE_SMS_EMAIL_V

apps.XXAKG_OE_DO2MOVE_NEW_V

select
*
from
XXAKG_OE_DO2MOVE_NEW_SMS

SELECT D.DO_HDR_ID,
          D.ORG_ID,
          xxakg_com_pkg.get_organization_name (D.ORG_ID) OPERATING_UNIT,
          D.DO_NUMBER,
          DO_STATUS,
          D.DO_DATE,
          D.DO_DATE_TIME,
          D.CUSTOMER_NUMBER,
          D.CUSTOMER_NAME,
          D.MODE_OF_TRANSPORT DO_MODE_OF_TRANSPORT,
          D.TRANSPORTER_VENDOR_ID DO_TRANSPORTER_VENDOR_ID,
          D.TRANSPORTER_NAME DO_TRANSPORTER_NAME,
          D.READY_FOR_PRINTING,
          D.PRINTING_DATE,
          D.ORDER_NUMBER,
          D.ORDER_HEADER_ID,
          D.ORDER_LINE_ID,
          D.LINE_NUMBER,
          D.ORDERED_ITEM_ID,
          D.ITEM_NUMBER,
          D.ITEM_DESCRIPTION,
          D.LINE_QUANTITY,
          D.CONVERT_BAG_QTY,
          D.SHIPPED_QTY,
          DECODE (UOM_CODE,
                  'MTN', NVL (D.SHIPPED_QTY, 0) * 20,
                  NVL (D.SHIPPED_QTY, 0))
             CONVERT_SHIPPED_BAG_QTY,
          XXAKG_BI_ONT_PKG.GET_ACTUAL_SHIPPED_DATE (D.ORG_ID,
                                                    D.ORDER_LINE_ID)
             ACTUAL_SHIPPED_DATE,
          D.UNIT_SELLING_PRICE,
          D.UOM_CODE,
          D.WAREHOUSE_ORG_ID DO_WAREHOUSE_ORG_ID,
          D.WAREHOUSE_ORG_CODE DO_WAREHOUSE_ORG_CODE,
          xxakg_com_pkg.get_organization_name (D.WAREHOUSE_ORG_ID)
             DO_WAREHOUSE_ORG_NAME,
          D.SHIP_TO_ORG_ID,
          D.SHIP_TO_LOCATION,
          D.ACTUAL_RETAILER_SHIP_TO,
          D.ITEM_PRICE_LOCATION,
          D.TERRITORY,
          D.PARENT_LINE_NUMBER,
          D.ORIGINAL_ITEM_NUMBER,
          D.PRICE_LIST_ID,
          D.PRICING_DATE,
          D.ACTUAL_DELIVERY_QTY,
          D.HAND_OVER_DATE,
          D.DELIVERY_MODE,
          D.RETAILER_PHONE_NO,
          (SELECT HCP.PHONE_NUMBER
            FROM APPS.HZ_PARTIES HP,APPS.HZ_RELATIONSHIPS HR,APPS.HZ_PARTIES H_CONTACT ,APPS.HZ_CONTACT_POINTS HCP,APPS.HZ_CUST_ACCOUNTS CUST,APPS.AR_CONTACTS_V ARC
            WHERE CUST.ACCOUNT_NUMBER=D.CUSTOMER_NUMBER AND ARC.CUSTOMER_ID=CUST.CUST_ACCOUNT_ID AND HR.SUBJECT_ID = H_CONTACT.PARTY_ID AND HR.OBJECT_ID = HP.PARTY_ID
            AND HCP.OWNER_TABLE_ID(+) = HR.PARTY_ID AND CUST.PARTY_ID = HP.PARTY_ID AND HCP.CONTACT_POINT_TYPE ='PHONE' AND HCP.STATUS = 'A' AND ARC.JOB_TITLE='Owner' 
            AND HR.RELATIONSHIP_ID=ARC.PARTY_RELATIONSHIP_ID) Owner_PHONE_NO,
          (SELECT ARC.EMAIL_ADDRESS EMAIL FROM APPS.AR_CONTACTS_V ARC,APPS.HZ_CUST_ACCOUNTS ACCT WHERE ARC.CUSTOMER_ID=ACCT.CUST_ACCOUNT_ID AND ACCT.ACCOUNT_NUMBER=D.CUSTOMER_NUMBER AND ARC.JOB_TITLE='Owner' AND ARC.STATUS='A')  Owner_EMAIL,
          (SELECT HCP.PHONE_NUMBER
            FROM APPS.HZ_PARTIES HP,APPS.HZ_RELATIONSHIPS HR,APPS.HZ_PARTIES H_CONTACT ,APPS.HZ_CONTACT_POINTS HCP,APPS.HZ_CUST_ACCOUNTS CUST,APPS.AR_CONTACTS_V ARC
            WHERE CUST.ACCOUNT_NUMBER=D.CUSTOMER_NUMBER AND ARC.CUSTOMER_ID=CUST.CUST_ACCOUNT_ID AND HR.SUBJECT_ID = H_CONTACT.PARTY_ID AND HR.OBJECT_ID = HP.PARTY_ID
            AND HCP.OWNER_TABLE_ID(+) = HR.PARTY_ID AND CUST.PARTY_ID = HP.PARTY_ID AND HCP.CONTACT_POINT_TYPE ='PHONE' AND HCP.STATUS = 'A' AND ARC.JOB_TITLE='Manager'
            AND HR.RELATIONSHIP_ID=ARC.PARTY_RELATIONSHIP_ID) Manager_PHONE_NO,
          (SELECT ARC.EMAIL_ADDRESS EMAIL FROM APPS.AR_CONTACTS_V ARC,APPS.HZ_CUST_ACCOUNTS ACCT WHERE ARC.CUSTOMER_ID=ACCT.CUST_ACCOUNT_ID AND ACCT.ACCOUNT_NUMBER=D.CUSTOMER_NUMBER AND ARC.JOB_TITLE='Manager' AND ARC.STATUS='A') Manager_EMAIL,
          M.MOV_ORD_HDR_ID,
          M.MOV_ORDER_NO,
          M.MOV_ORDER_DATE,
          M.MOV_ORDER_STATUS,
          M.GATE_PASS_NO,
          M.GATE_PASS_DATE,
          M.FINAL_DESTINATION,
          M.WAREHOUSE_ORG_ID MOVE_WAREHOUSE_ORG_ID,
          M.WAREHOUSE_ORG_CODE MOVE_WAREHOUSE_ORG_CODE,
          xxakg_com_pkg.get_organization_name (M.WAREHOUSE_ORG_ID)
             MOVE_WAREHOUSE_ORG_NAME,
          M.TRANSPORT_MODE MOVE_MODE_OF_TRANSPORT,
          M.VEHICLE_NO,
          M.GATE_OUT,
          M.GATE_OUT_DATE,
          M.GATE_IN,
          M.GATE_IN_DATE,
          M.VEHICLE_TYPE,
          M.TRANSPORTER_VENDOR_ID MOVE_TRANSPORTER_VENDOR_ID,
          M.TRANSPORTER_NAME MOVE_TRANSPORTER_NAME,
          M.INITIAL_GATE_IN,
          M.INITIAL_GATE_IN_DATE,
          M.EMPTY_TRUCK_WT,
          M.EMPTY_TRUCK_WT_DATE,
          M.DRIVER_NAME,
          M.SCALE_IN_WT,
          M.FULL_TRUCK_WT_DATE,
          M.SCALE_OUT_WT,
          M.HIRE_RATE_AP,
          M.HIRE_RATE_AR,
          M.CONFIRM_FLAG,
          M.CONFIRM_DATE,
          M.TRANSFER_LOADING_FLAG,
          M.TRANSFER_LOADING_DATE,
          M.TRUCK_LOADING_FLAG,
          M.TRUCK_LOADING_DATE,
          M.VAT_RECEIVED_FLAG,
          M.VAT_RECEIVED_DATE,
          M.CHALLANED_FLAG,
          M.CHALLANED_DATE,
          M.VAT_CHALLAN_NO,
          M.VAT_CHALLAN_DATE,
          M.VAT_IN_FLAG,
          M.VAT_IN_DATE,
          M.MOV_ORDER_TYPE,
          M.METER_READING_START,
          M.METER_READING_END,
          M.OIL_REFILL_QTY_CNG,
          M.OIL_REFILL_QTY_OCTANE,
          M.KM_PER_LITRE,
          M.AR_FLAG,
          M.DRIVER_MOBILE,
          M.CONFIRMED_DATE
     FROM (SELECT DH.DO_HDR_ID,
                  DH.ORG_ID,
                  DH.DO_NUMBER,
                  DO_STATUS,
                  TRUNC (DH.DO_DATE) DO_DATE,
                  DH.DO_DATE DO_DATE_TIME,
                  CUSTOMER_NUMBER,
                  CUSTOMER_NAME,
                  DH.MODE_OF_TRANSPORT,
                  DH.TRANSPORTER_VENDOR_ID,
                  DH.TRANSPORTER_NAME,
                  DH.READY_FOR_PRINTING,
                  DH.PRINTING_DATE,
                  ORDER_NUMBER,
                  ORDER_HEADER_ID,
                  ORDER_LINE_ID,
                  LINE_NUMBER,
                  ORDERED_ITEM_ID,
                  ITEM_NUMBER,
                  ITEM_DESCRIPTION,
                  NVL (LINE_QUANTITY, 0) LINE_QUANTITY,
                  XXAKG_BI_ONT_PKG.GET_SHIPPED_QTY (DL.ORG_ID,
                                                    DL.ORDER_LINE_ID)
                     SHIPPED_QTY,
                  DECODE (UOM_CODE,
                          'MTN', NVL (LINE_QUANTITY, 0) * 20,
                          NVL (LINE_QUANTITY, 0))
                     CONVERT_BAG_QTY,
                  GET_UNIT_SELLING_PRICE (DH.ORG_ID,
                                          DH.DO_STATUS,
                                          ORDER_HEADER_ID,
                                          ORDER_LINE_ID,
                                          ORDERED_ITEM_ID)
                     UNIT_SELLING_PRICE,
                  UOM_CODE,
                  DL.WAREHOUSE_ORG_ID,
                  WAREHOUSE_ORG_CODE,
                  SHIP_TO_ORG_ID,
                  SHIP_TO_LOCATION,
                  ACTUAL_RETAILER_SHIP_TO,
                  ITEM_PRICE_LOCATION,
                  DL.TERRITORY,
                  DL.PARENT_LINE_NUMBER,
                  DL.ORIGINAL_ITEM_NUMBER,
                  DL.PRICE_LIST_ID,
                  DL.PRICING_DATE,
                  DL.ACTUAL_DELIVERY_QTY,
                  DH.HAND_OVER_DATE,
                  DH.DELIVERY_MODE,
                  XXAKG_ONT_PKG.GET_RETAILER_PHONE_NO (DL.SHIP_TO_ORG_ID)
                     RETAILER_PHONE_NO
             FROM XXAKG_DEL_ORD_HDR dh, XXAKG_DEL_ORD_DO_LINES dl
            WHERE dh.DO_HDR_ID = dl.DO_HDR_ID AND DH.ORG_ID = 85) d,
          (SELECT MH.MOV_ORD_HDR_ID,
                  DO_HDR_ID,
                  MOV_ORDER_NO,
                  TRUNC (MOV_ORDER_DATE) MOV_ORDER_DATE,
                  MOV_ORDER_STATUS,
                  GATE_PASS_NO,
                  GATE_PASS_DATE,
                  FINAL_DESTINATION,
                  WAREHOUSE_ORG_CODE,
                  WAREHOUSE_ORG_ID,
                  TRANSPORT_MODE,
                  VEHICLE_NO,
                  GATE_OUT,
                  GATE_OUT_DATE,
                  GATE_IN,
                  GATE_IN_DATE,
                  VEHICLE_TYPE,
                  TRANSPORTER_NAME,
                  TRANSPORTER_VENDOR_ID,
                  INITIAL_GATE_IN,
                  INITIAL_GATE_IN_DATE,
                  EMPTY_TRUCK_WT,
                  EMPTY_TRUCK_WT_DATE,
                  DRIVER_NAME,
                  SCALE_IN_WT,
                  FULL_TRUCK_WT_DATE,
                  SCALE_OUT_WT,
                  HIRE_RATE_AP,
                  HIRE_RATE_AR,
                  CONFIRM_FLAG,
                  CONFIRM_DATE,
                  TRANSFER_LOADING_FLAG,
                  ML.TRANSFER_LOADING_DATE,
                  TRUCK_LOADING_FLAG,
                  TRUCK_LOADING_DATE,
                  VAT_RECEIVED_FLAG,
                  VAT_RECEIVED_DATE,
                  CHALLANED_FLAG,
                  CHALLANED_DATE,
                  ML.VAT_CHALLAN_NO,
                  ML.VAT_CHALLAN_DATE,
                  VAT_IN_FLAG,
                  VAT_IN_DATE,
                  MOV_ORDER_TYPE,
                  METER_READING_START,
                  METER_READING_END,
                  OIL_REFILL_QTY_CNG,
                  OIL_REFILL_QTY_OCTANE,
                  KM_PER_LITRE,
                  ML.AR_FLAG,
                  mh.DRIVER_MOBILE,
                  MH.CONFIRMED_DATE
             FROM XXAKG_MOV_ORD_HDR mh, XXAKG_MOV_ORD_DTL ml
            WHERE mh.MOV_ORD_HDR_ID = ml.MOV_ORD_HDR_ID AND mh.ORG_ID = 85) m
    WHERE d.DO_HDR_ID = m.DO_HDR_ID(+)
    AND d.DO_HDR_ID='2221287';
    
    
   SELECT
    Owner_PHONE_NO,
    Manager_PHONE_NO,
    OFFICER_PHONE_NO, 
    ' Dear Customer, '|| 
    'Your Order No: '||ORDER_NUMBER||','||
    'Dated: '|| TO_CHAR(ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS')||
    ', Product: '||DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||CANCELLED_QUANTITY||' '||UOM_CODE||' is Cancelled'||', '||
    ' Shah Cement Ind. Ltd.' SMS,
    ' Order Cancel Info: '|| 
    'Customer: '||CUSTOMER_NAME||', '||'Order No: '||ORDER_NUMBER||','||
    'Dated: '|| TO_CHAR(ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS')||
    ', Product: '||DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||CANCELLED_QUANTITY||' '||UOM_CODE||' is Cancelled'||', '||
    ' Shah Cement Ind. Ltd.' MKT_SMS
    ,TO_CHAR (LAST_UPDATE_DATE, 'DD-MON-RR') LAST_UPDATE_DATE
FROM
XXAKG_SCIL_ORDER_SMS_V
WHERE ORDER_LINE_STATUS='CANCELLED'
--AND TO_CHAR (LAST_UPDATE_DATE, 'DD-MON-RR') = '28-MAY-19'
AND ORDER_NUMBER='1601232'