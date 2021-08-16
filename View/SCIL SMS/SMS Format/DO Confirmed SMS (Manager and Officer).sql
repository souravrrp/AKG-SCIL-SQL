SELECT  
    OFFICER_NUMBER, 
    MANAGER_PHONE_NO,
    'DO Confirmation:'|| 
    ' Customer: '||CUSTOMER_NAME||
    ' Site: '||SHIP_TO_LOCATION||
    'DO Number: '||DO_NUMBER||
    ' Product: '||DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||LINE_QUANTITY||' '||UOM_CODE||' '||
    'Shah Cement' MKT_SMS
FROM
APPS.XXAKG_OE_DO2MOVE_NEW_SMS
WHERE 1=1
and DO_STATUS='CONFIRMED'
AND TRUNC(CONFIRMED_DATE)='03-NOV-19'