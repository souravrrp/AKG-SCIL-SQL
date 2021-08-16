select
*
FROM apps.XXAKG_AR_PAYMENT_SCHEDULES_V PS


SELECT 'ACP' SOURCE,
          ORG_ID,
          CUSTOMER_ID,
          NULL,
          GL_DATE,
          DR_AMOUNT,
          NULL,
          NULL,
          NULL
     FROM apps.XXAKG_AR_CASH_PAYMENTS_V ACP
    WHERE 1=1
    --and NVL (ACP.STATUS, 'AKG') <> 'VOIDED';
    
    
    SELECT PAY.ORG_ID,
          CUST.CUST_ACCOUNT_ID CUSTOMER_ID,
          CUST.ACCOUNT_NUMBER CUSTOMER_NUMBER,
          PARTY.PARTY_NAME CUSTOMER,
          apps.XXAKG_AR_PKG.GET_AREA_FROM_CUST_ID (CUST.CUST_ACCOUNT_ID) AREA_NAME,
          apps.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CUST.CUST_ACCOUNT_ID) ADDRESS,
          PAY.DOC_SEQUENCE_VALUE VOUCHER,
          DECODE (PAY.STATUS_LOOKUP_CODE,
                  'CLEARED BUT UNACCOUNTED', 'CLEARED',
                  PAY.STATUS_LOOKUP_CODE),
          PAY.CHECK_NUMBER,
             PAY.BANK_ACCOUNT_NUM
          || ', '
          || apps.XXAKG_AP_PKG.GET_BANK_NAME_FROM_CHECK_ID (PAY.CHECK_ID),
          PAY.CHECK_NUMBER || ', ' || PAY.BANK_ACCOUNT_NUM PAYMENT_NUMBER,
          NVL (apps.XXAKG_CE_PKG.GET_CLEARED_AMT_FROM_CHECK_ID (PAY.CHECK_ID),
               NVL (PAY.BASE_AMOUNT, PAY.AMOUNT))
             DR_AMOUNT,
          0 CR_AMOUNT,
          NVL (apps.XXAKG_CE_PKG.GET_CLEARED_AMT_FROM_CHECK_ID (PAY.CHECK_ID),
               NVL (PAY.BASE_AMOUNT, PAY.AMOUNT))
             TOTAL,
          NVL (apps.XXAKG_CE_PKG.GET_GL_DATE_FROM_CHECK_ID (PAY.CHECK_ID),
               TRUNC (PAY.CHECK_DATE))
             GL_DATE
     FROM apps.HZ_CUST_ACCOUNTS CUST, apps.HZ_PARTIES PARTY, apps.AP_CHECKS_ALL PAY
    WHERE     CUST.PARTY_ID = PARTY.PARTY_ID
          AND PARTY.PARTY_ID = PAY.PARTY_ID
          AND PAY.STATUS_LOOKUP_CODE IS NOT NULL
          and CUST.ACCOUNT_NUMBER='31157'
          --AND PAY.VENDOR_ID = -222;
          
          select
          *
          from
          apps.fnd_flex_values_vl where 1=1
          and flex_value like '%NEGOTI%'
          
          