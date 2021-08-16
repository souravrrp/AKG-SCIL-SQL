SELECT
CUSTOMER_NUMBER||'-'||CUSTOMER_NAME CUSTOMER,
AM_PHONE_NO,
DEALER_PHONE_NO,
'Dated: '||TO_CHAR(TO_DATE(:P_DATE),'DD-MON-YY')||
' Dear Customer, Your outstanding ledger Balance is BDT '||
XXAKG_AR_PKG.GET_CUSTOMER_OPEN_BALance (83,
                                        CUSTOMER_ID,
                                        :P_DATE)||' at the end of '||TO_CHAR(TRUNC(TO_DATE(:P_DATE), 'MM') - 1,'Month YYYY')||'.' SMS 
FROM
APPS.XXAKG_CER_MONTHEND_BALANCE_SMS