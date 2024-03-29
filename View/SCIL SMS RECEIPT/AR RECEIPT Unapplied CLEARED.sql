SELECT A.CASH_RECEIPT_ID,
          A.PAY_FROM_CUSTOMER,
          A.RECEIPT_NUMBER,
          A.RECEIPT_DATE,
          A.CONFIRMED_FLAG,
          A.CUSTOMER_SITE_USE_ID,
          APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (C.CUSTOMER_ID) REGION,
          C.CUSTOMER_NUMBER,
          C.CUSTOMER_NAME,
          A.DEPOSIT_DATE,
          A.DOC_SEQUENCE_VALUE,
          A.ORG_ID,
          A.REMIT_BANK_ACCT_USE_ID,
          A.EXCHANGE_RATE,
          A.STATUS,
          A.TYPE,
          A.CURRENCY_CODE,
          A.AMOUNT,
          B.STATUS RECEIPT_CURR_STATUS,
          B.TRX_DATE,
          B.CURRENT_RECORD_FLAG,
          B.GL_DATE,
          B.ACCTD_AMOUNT,
          CBA.BANK_ACCOUNT_NUM,
          CBA.BANK_ID,
          CBAU.BANK_ACCT_USE_ID,
          CBAU.BANK_ACCOUNT_ID,
          BNK.BANK_NAME,
          BRNCH.BANK_BRANCH_NAME,
--          C.PHONE_NUMBER,
          B.LAST_UPDATE_DATE
     FROM APPS.AR_CASH_RECEIPTS_ALL A,
          APPS.AR_CASH_RECEIPT_HISTORY_ALL B,
          APPS.CE_BANK_ACCOUNTS CBA,
          APPS.CE_BANK_ACCT_USES_ALL CBAU,
          APPS.CE_BANK_BRANCHES_V BRNCH,
          APPS.CE_BANKS_V BNK,
          APPS.XXAKG_AR_CUSTOMER_SITE_V C
    WHERE     A.CASH_RECEIPT_ID = B.CASH_RECEIPT_ID
          AND CBAU.BANK_ACCT_USE_ID = A.REMIT_BANK_ACCT_USE_ID
          AND CBAU.BANK_ACCOUNT_ID = CBA.BANK_ACCOUNT_ID
          AND CBA.BANK_BRANCH_ID = BRNCH.BRANCH_PARTY_ID
          AND CBA.BANK_ID = BRNCH.BANK_PARTY_ID
          AND BRNCH.BANK_PARTY_ID = BNK.BANK_PARTY_ID
          AND A.PAY_FROM_CUSTOMER = C.CUSTOMER_ID
          AND A.ORG_ID = 85
          AND B.CURRENT_RECORD_FLAG = 'Y'
          AND A.STATUS != 'REV'
          AND C.SITE_USE_CODE = 'BILL_TO'
          AND A.STATUS ='UNAPP'
          AND B.STATUS ='CLEARED'
--          AND TO_CHAR(B.LAST_UPDATE_DATE,'RRRR')='2019'
--          AND A.CASH_RECEIPT_ID='1359883'
--          AND TO_CHAR(B.LAST_UPDATE_DATE,'DD-MON-RRRR')='31-DEC-2015';
AND ROWNUM<=1