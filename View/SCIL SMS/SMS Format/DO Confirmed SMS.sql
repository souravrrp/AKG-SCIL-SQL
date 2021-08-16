SELECT  
    OWNER_PHONE_NO,
    MANAGER_PHONE_NO,
    OFFICER_NUMBER, 
    ' Dear Customer, '|| 
    'Your Order No: '||ORDER_NUMBER||','||
    ' DO No: '||DO_NUMBER||' is Confirmed.'||
    ' Site: '||SHIP_TO_LOCATION||
    ', Product: '||DECODE (ITEM_DESCRIPTION,'Ordinary Portland Cement (Bulk)', 'OPC-Bulk',
                                'Ordinary Portland Cement (Bag)','OPC',
                                'Popular Cement - Stitch Bag','PP-Stitch',
                                'Special Cement - Stitch Bag','SP-Stitch',
                                'Popular Cement','PP',
                                'Special Cement','SP',
                                'BULK Cement (Special)','SP-Bulk',
                                'Special Cement - Jumbo Bag','SP-Jumbo Bag',
                                'Ordinary Portland Cement - Jumbo Bag','OPC-Jumbo Bag')||' '||LINE_QUANTITY||' '||UOM_CODE||' '||
    'Shah Cement Ind. Ltd.' SMS
FROM
APPS.XXAKG_OE_DO2MOVE_NEW_SMS
WHERE 1=1
and READY_FOR_PRINTING='Y'
