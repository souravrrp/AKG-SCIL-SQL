SELECT
    OWNER_PHONE_NO,
    MANAGER_PHONE_NO,
    OFFICER_PHONE_NO, 
    ' Dear Customer, '|| 
    'Your Order No: '||ORDER_NUMBER||','||
    'Dated: '|| TO_CHAR(ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS')||
    ', Product: '||LISTAGG(DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||CANCELLED_QUANTITY||' '||UOM_CODE, ',') WITHIN GROUP (ORDER BY ITEM_CODE,UOM_CODE)||' is Cancelled'||', '||
    ' Shah Cement Ind. Ltd.' SMS,
    ' Order Cancel Info: '|| 
    'Customer: '||CUSTOMER_NAME||', '||'Order No: '||ORDER_NUMBER||','||
    'Dated: '|| TO_CHAR(ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS')||
    ', Product: '||LISTAGG(DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||CANCELLED_QUANTITY||' '||UOM_CODE, ',') WITHIN GROUP (ORDER BY ITEM_CODE,UOM_CODE)||' is Cancelled'||', '||
    ' Shah Cement Ind. Ltd.' MKT_SMS
    ,TO_CHAR (LAST_UPDATE_DATE, 'DD-MON-RR') LAST_UPDATE_DATE
FROM
XXAKG_SCIL_ORDER_SMS_V
WHERE ORDER_LINE_STATUS='CANCELLED'
AND TO_CHAR (LAST_UPDATE_DATE, 'DD-MON-RR') = '26-FEB-17'
--AND ORDER_NUMBER='1601232'
GROUP BY
OWNER_PHONE_NO,
MANAGER_PHONE_NO,
OFFICER_PHONE_NO,
ORDER_NUMBER,
ORDERED_DATE,
CUSTOMER_NAME,
LAST_UPDATE_DATE
