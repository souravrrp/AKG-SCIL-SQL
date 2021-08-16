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
          B.LAST_UPDATE_DATE,
          (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                  AND ARC.JOB_TITLE = 'Owner')
             Owner_PHONE_NO,
          (SELECT DISTINCT NVL (HOC.EMAIL_ADDRESS, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'EMAIL'
                  AND ARC.JOB_TITLE = 'Owner')
             Owner_EMAIL,
          (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                  AND ARC.JOB_TITLE = 'Manager')
             Manager_PHONE_NO,
          (SELECT DISTINCT NVL (HOC.EMAIL_ADDRESS, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'EMAIL'
                  AND ARC.JOB_TITLE = 'Manager')
             Manager_EMAIL,
          (SELECT NVL (HCA.ATTRIBUTE9, 0)
             FROM APPS.HZ_CUST_ACCOUNTS HCA
            WHERE HCA.CUST_ACCOUNT_ID = C.CUSTOMER_ID)
             OFFICER_PHONE_NO
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
          AND B.STATUS ='REMITTED'
--          AND TRUNC(B.CREATION_DATE)>TRUNC(B.TRX_DATE)
--          AND TO_CHAR(B.LAST_UPDATE_DATE,'RRRR')='2019'
--          AND A.CASH_RECEIPT_ID='1359883'
          AND TO_CHAR(B.CREATION_DATE,'DD-MON-RRRR')='19-MAY-2019'
--          AND ROWNUM<=1
          

SELECT  
    OWNER_PHONE_NO,
    MANAGER_PHONE_NO,
    OFFICER_PHONE_NO, 
    'Dear Customer, Your Payment of Tk='||AMOUNT||' by '||BANK_NAME||' '||BANK_BRANCH_NAME||' dated: '||RECEIPT_DATE||' is Confirmed and Posted in your ledger accordingly. Shah Cement Ind. Ltd.' SMS
    ,v.*
FROM
APPS.XXAKG_SCIL_MR_SMS_V v
WHERE 1=1
AND ROWNUM<=3