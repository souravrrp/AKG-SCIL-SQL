WITH XX_CUSTOMER_SUMMARY_TAB
     AS (  SELECT TO_CHAR(TO_DATE(:P_DATE_TO),'Month YYYY') PERIOD_NAME,
                  CUSTOMER_ID,
                  XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
                     FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
                    WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                          AND ARC.CUSTOMER_ID = CB.CUSTOMER_ID
                          AND HOC.STATUS = 'A'
                          AND HOC.CONTACT_STATUS = 'A'
                          AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                          AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                          AND ARC.JOB_TITLE = 'Dealer')
                     DEALER_PHONE_NO,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
             FROM XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     ORG_ID = 83
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE <= :P_DATE_TO
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE CB.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT TO_CHAR(PS.GL_DATE,'Month YYYY') PERIOD_NAME,
                  CUSTOMER_ID,
                  XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
                     FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
                    WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                          AND ARC.CUSTOMER_ID = PS.CUSTOMER_ID
                          AND HOC.STATUS = 'A'
                          AND HOC.CONTACT_STATUS = 'A'
                          AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                          AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                          AND ARC.JOB_TITLE = 'Dealer')
                     DEALER_PHONE_NO,
                  0 OPEN_BALANCE,
                  SUM (GREATEST (PS.AMOUNT_DUE_ORIGINAL, 0)) DR_AMOUNT,
                  (0 - SUM (LEAST (PS.AMOUNT_DUE_ORIGINAL, 0))) CR_AMOUNT
             FROM XXAKG_AR_PAYMENT_SCHEDULES_V PS
            WHERE     NOT EXISTS
                             (SELECT 1
                                FROM AR_CASH_RECEIPTS_ALL CR
                               WHERE     PS.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                                     AND PS.ORG_ID = CR.ORG_ID
                                     AND NVL (CR.STATUS, 'AKG') IN ('CCRR', 'CC_CHARGEBACK_REV', 'NSF', 'REV', 'STOP'))
                  AND PS.ORG_ID = 83
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR PS.CUSTOMER_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO)
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE PS.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY PS.ORG_ID, PS.CUSTOMER_ID,TO_CHAR(PS.GL_DATE,'Month YYYY'))
  SELECT 
         CUSTOMER,
         DEALER_PHONE_NO,
         'Dated: '||TRUNC(SYSDATE)||
         ' Dear Customer, Your outstanding ledger Balance is BDT '||
         SUM (OPEN_BALANCE)||' at the end of '||PERIOD_NAME||'.' SMS
    FROM XX_CUSTOMER_SUMMARY_TAB
GROUP BY 
         CUSTOMER
         ,DEALER_PHONE_NO
         ,PERIOD_NAME
         
--------------------------------------------------------------------------------

SELECT  C.CUSTOMER_NUMBER||'-'||C.CUSTOMER_NAME CUSTOMER,
        (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
                     FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
                    WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                          AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                          AND HOC.STATUS = 'A'
                          AND HOC.CONTACT_STATUS = 'A'
                          AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                          AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                          AND ARC.JOB_TITLE = 'AM')
                     AM_PHONE_NO,
        (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
                     FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
                    WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                          AND ARC.CUSTOMER_ID = C.CUSTOMER_ID
                          AND HOC.STATUS = 'A'
                          AND HOC.CONTACT_STATUS = 'A'
                          AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                          AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                          AND ARC.JOB_TITLE = 'Dealer')
                     DEALER_PHONE_NO,
'Dated: '||TO_CHAR(TO_DATE(:P_DATE),'DD-MON-YY')||
' Dear Customer, Your outstanding ledger Balance is BDT '||
XXAKG_AR_PKG.GET_CUSTOMER_OPEN_BALance (83,
                                        C.CUSTOMER_ID,
                                        :P_DATE)||' at the end of '||TO_CHAR(TRUNC(TO_DATE(:P_DATE), 'MM') - 1,'Month YYYY')||'.' SMS 
--,C.*
FROM
APPS.AR_CUSTOMERS C
WHERE (:P_CUSTOMER_NUMBER IS NULL OR (C.CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))
AND (:P_CUSTOMER_STATUS IS NULL OR (C.STATUS = :P_CUSTOMER_STATUS))
AND EXISTS(SELECT 1 FROM APPS.XXAKG_DISTRIBUTOR_BLOCK_M R WHERE R.ORG_ID=83 AND C.CUSTOMER_ID=R.CUSTOMER_ID AND (:P_REGION_NAME IS NULL OR (R.REGION_NAME = :P_REGION_NAME))) 



--------------------------------------------------------------------------------

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
--WHERE (:P_CUSTOMER_NUMBER IS NULL OR (CUSTOMER_NUMBER = :P_CUSTOMER_NUMBER))