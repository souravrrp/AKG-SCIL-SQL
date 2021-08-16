SELECT  
    OWNER_PHONE_NO,
    MANAGER_PHONE_NO,
    OFFICER_PHONE_NO, 
    'Dear Customer, Your Payment of Tk='||AMOUNT||' by '||BANK_NAME||', Branch: '||BANK_BRANCH_NAME||' Dated: '||RECEIPT_DATE||' is Confirmed and Posted in your ledger accordingly. Shah Cement Ind. Ltd.' SMS
FROM
APPS.XXAKG_SCIL_MR_SMS_V v
where trunk(creation_date)>'20-MAY-2019'
