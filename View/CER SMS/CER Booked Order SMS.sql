SELECT 
    AM_PHONE_NO,
    DEALER_PHONE_NO,
    BOOKED_DATE, 
    ORDER_NUMBER, 
    'Dated: '||trunc(BOOKED_DATE)||' Dear Customer, Your required order is Accepted. Order Number: '||ORDER_NUMBER||' Total Qty: '||SUM(ORDERED_QUANTITY)||' '||UOM_CODE||' Abul Khair Ceramic Industries Ltd.' SMS 
FROM APPS.XXAKG_CER_ORDER_SMS_V V 
   WHERE ORDER_STATUS='BOOKED'   
    --AND  TRUNC(BOOKED_DATE) > '19-May-2019' 
    AND CUSTOMER_NUMBER IN (35055)
    GROUP BY
    AM_PHONE_NO,
    DEALER_PHONE_NO,
    BOOKED_DATE, 
    ORDER_NUMBER
    ,UOM_CODE
