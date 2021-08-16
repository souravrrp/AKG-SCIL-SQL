--------------------------------------------------------------------------------31-Oct-2019-- As per instruction of Shazzad Sir

SELECT CUSTOMER_NUMBER, 
    DEALER_PHONE_NO PHONE_NUMBER,
    ' Dated: '||CREATION_DATE||
    ' Dear Customer, Your Payment of BDT '||AMOUNT||' by Bank Name '||BANK_NAME||' Dated: '||CREATION_DATE||' is Confirmed and Posted to your ledger accordingly. Abul Khair Ceramic Industries Ltd.' SMS
FROM
APPS.XXAKG_CER_MR_SMS_V v
WHERE TRUNC(CLEARED_DATE)='30-OCT-2019'
--AND CUSTOMER_NUMBER='35055' 


--------------------------------------------------------------------------------

SELECT CUSTOMER_NUMBER, 
    DEALER_PHONE_NO PHONE_NUMBER,
    ' Dated: '||CLEARED_DATE||
    ' Dear Customer, Your Payment of BDT '||AMOUNT||' by Bank Name '||BANK_NAME||' Dated: '||CLEARED_DATE||' is Confirmed and Posted to your ledger accordingly. Abul Khair Ceramic Industries Ltd.' SMS
FROM
APPS.XXAKG_CER_MR_SMS_V v
WHERE CUSTOMER_NUMBER='35055'
--AND TRUNC(CREATION_DATE)>='29-AUG-2019'
