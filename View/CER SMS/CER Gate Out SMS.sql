SELECT  
    AM_PHONE_NO,
    DEALER_PHONE_NO, 
    'Dated: '|| TO_CHAR(CONFIRMED_DATE,'DD-MON-YYYY')||
    ' Dear Customer, '|| 
    'Your Order No '||ORDER_NUMBER||' is delivered.'||
    ' DO No: '||DO_NUMBER||
    ' Delivery Qty: '||sum(QUANTITY)||' '||UOM_CODE||
    ' Site Address: '||DELIVERY_LOCATION||
    ' Truck Number: '||VEHICLE_NO||
    ', Driver No: '||DRIVER_MOBILE||
    ' Abul Khair Ceramic Industries Ltd.' SMS
FROM
APPS.XXAKG_CER_DO2MOVE_SMS
WHERE 1=1
--AND TRUNC(CONFIRMED_DATE)>='01-JAN-17'
AND CUSTOMER_NUMBER='35055'
GROUP BY
ORDER_NUMBER
,DO_NUMBER
,UOM_CODE
,AM_PHONE_NO
,TO_CHAR(CONFIRMED_DATE,'DD-MON-YYYY')
,DELIVERY_LOCATION
,DEALER_PHONE_NO
,VEHICLE_NO
,DRIVER_MOBILE