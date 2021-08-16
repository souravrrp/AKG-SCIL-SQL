WITH XX_CUSTOMER_SUMMARY_TAB
     AS (  SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CB.CUSTOMER_ID) ADDRESS,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
                  ,(APPS.XXAKG_AR_PKG.GET_CUST_SALES_AMOUNT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)-
                        APPS.XXAKG_AR_PKG.GET_CUST_SALES_RETURN_AMOUNT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)) SALES_AMOUNT
                  ,((APPS.XXAKG_AR_PKG.GET_CONFIRMED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)+
                    APPS.XXAKG_AR_PKG.GET_REMITTED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)+
                    APPS.XXAKG_AR_PKG.GET_CLEARED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO))-
                        APPS.XXAKG_AR_PKG.GET_REVERSED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)) RECEIPT_AMOUNT
                  ,APPS.XXAKG_AR_PKG.GET_CUST_ADJUSTMENT_TOTAL(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO) ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE < :P_DATE_FROM
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE CB.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (PS.CUSTOMER_ID) ADDRESS,
                  0 OPEN_BALANCE,
                  SUM (GREATEST (PS.AMOUNT_DUE_ORIGINAL, 0)) DR_AMOUNT,
                  (0 - SUM (LEAST (PS.AMOUNT_DUE_ORIGINAL, 0))) CR_AMOUNT
                  ,0 SALES_AMOUNT
                  ,0 RECEIPT_AMOUNT
                  ,0 ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_PAYMENT_SCHEDULES_V PS
            WHERE     NOT EXISTS
                             (SELECT 1
                                FROM APPS.AR_CASH_RECEIPTS_ALL CR
                               WHERE     PS.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                                     AND PS.ORG_ID = CR.ORG_ID
                                     AND NVL (CR.STATUS, 'AKG') IN ('CCRR', 'CC_CHARGEBACK_REV', 'NSF', 'REV', 'STOP'))
                  AND PS.ORG_ID = :P_ORG_ID
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR PS.CUSTOMER_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO)
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE PS.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
                  GROUP BY PS.CUSTOMER_ID
                  UNION ALL----------------------------------------------------------------------------------------------------------------------------------------------------------------
                  SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CB.CUSTOMER_ID) ADDRESS,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
                  ,(APPS.XXAKG_AR_PKG.GET_CUST_SALES_AMOUNT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)-
                        APPS.XXAKG_AR_PKG.GET_CUST_SALES_RETURN_AMOUNT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)) SALES_AMOUNT
                  ,((APPS.XXAKG_AR_PKG.GET_CONFIRMED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)+
                    APPS.XXAKG_AR_PKG.GET_REMITTED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)+
                    APPS.XXAKG_AR_PKG.GET_CLEARED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO))-
                        APPS.XXAKG_AR_PKG.GET_REVERSED_RECEIPT(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO)) RECEIPT_AMOUNT
                  ,APPS.XXAKG_AR_PKG.GET_CUST_ADJUSTMENT_TOTAL(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO) ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     (:P_ORG_ID IS NULL OR CB.ORG_ID = :P_ORG_ID)
                  --AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  --AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE < :P_DATE_FROM
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCT_RELATE_ALL CARA WHERE CB.ORG_ID = CARA.ORG_ID AND CB.CUSTOMER_ID=CARA.RELATED_CUST_ACCOUNT_ID AND CARA.STATUS='A' AND (:P_CUSTOMER_ID_FROM IS NULL OR CARA.CUST_ACCOUNT_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO))
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE CB.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (PS.CUSTOMER_ID) ADDRESS,
                  0 OPEN_BALANCE,
                  SUM (GREATEST (PS.AMOUNT_DUE_ORIGINAL, 0)) DR_AMOUNT,
                  (0 - SUM (LEAST (PS.AMOUNT_DUE_ORIGINAL, 0))) CR_AMOUNT
                  ,0 SALES_AMOUNT
                  ,0 RECEIPT_AMOUNT
                  ,0 ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_PAYMENT_SCHEDULES_V PS
            WHERE     NOT EXISTS
                             (SELECT 1
                                FROM APPS.AR_CASH_RECEIPTS_ALL CR
                               WHERE     PS.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                                     AND PS.ORG_ID = CR.ORG_ID
                                     AND NVL (CR.STATUS, 'AKG') IN ('CCRR', 'CC_CHARGEBACK_REV', 'NSF', 'REV', 'STOP'))
                  AND PS.ORG_ID = :P_ORG_ID
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCT_RELATE_ALL CARA WHERE PS.ORG_ID = CARA.ORG_ID AND PS.CUSTOMER_ID=CARA.RELATED_CUST_ACCOUNT_ID AND CARA.STATUS='A' AND (:P_CUSTOMER_ID_FROM IS NULL OR CARA.CUST_ACCOUNT_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO))
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE PS.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY PS.ORG_ID, PS.CUSTOMER_ID)
  SELECT REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS,
         SUM (OPEN_BALANCE) OPEN_BALANCE,
         SUM (DR_AMOUNT) DR_AMOUNT,
         SUM (CR_AMOUNT) CR_AMOUNT,
         SUM (SALES_AMOUNT) SALES_AMOUNT,
         SUM (RECEIPT_AMOUNT) RECEIPT_AMOUNT,
         SUM (SALES_AMOUNT) ADJUSTMENT_AMOUNT
    FROM XX_CUSTOMER_SUMMARY_TAB CS
GROUP BY REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS
ORDER BY 1

--------------------------------------------------------------------------------

WITH XX_CUSTOMER_SUMMARY_TAB
     AS (  SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CB.CUSTOMER_ID) ADDRESS,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
                  ,APPS.XXAKG_AR_PKG.GET_CUST_ADJUSTMENT_TOTAL(:P_CUSTOMER_ID_FROM,
                                   :P_ORG_ID,
                                   :P_DATE_FROM,
                                   :P_DATE_TO) ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE < :P_DATE_FROM
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE CB.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (PS.CUSTOMER_ID) ADDRESS,
                  0 OPEN_BALANCE,
                  SUM (GREATEST (PS.AMOUNT_DUE_ORIGINAL, 0)) DR_AMOUNT,
                  (0 - SUM (LEAST (PS.AMOUNT_DUE_ORIGINAL, 0))) CR_AMOUNT
                  ,0 ADJUSTMENT_AMOUNT
             FROM APPS.XXAKG_AR_PAYMENT_SCHEDULES_V PS
            WHERE     NOT EXISTS
                             (SELECT 1
                                FROM APPS.AR_CASH_RECEIPTS_ALL CR
                               WHERE     PS.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                                     AND PS.ORG_ID = CR.ORG_ID
                                     AND NVL (CR.STATUS, 'AKG') IN ('CCRR', 'CC_CHARGEBACK_REV', 'NSF', 'REV', 'STOP'))
                  AND PS.ORG_ID = :P_ORG_ID
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR PS.CUSTOMER_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO)
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE PS.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY PS.ORG_ID, PS.CUSTOMER_ID)
  SELECT REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS,
         SUM (OPEN_BALANCE) OPEN_BALANCE,
         SUM (DR_AMOUNT) DR_AMOUNT,
         SUM (CR_AMOUNT) CR_AMOUNT
         ,SUM(ADJUSTMENT_AMOUNT) ADJUSTMENT_AMOUNT
    FROM XX_CUSTOMER_SUMMARY_TAB
GROUP BY REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS
ORDER BY 1

---------------------------------ValueSet-----------------------------------------------------

(SELECT 'Active' STATUS,'A' VAL  FROM DUAL UNION ALL  SELECT  'Inactive' STATUS,'I' VAL FROM DUAL)


---------------------------------Oroginal-----------------------------------------------------

WITH XX_CUSTOMER_SUMMARY_TAB
     AS (  SELECT XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CB.CUSTOMER_ID) ADDRESS,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
             FROM XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE < :P_DATE_FROM
                  AND (:P_REGION IS NULL OR XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) = :P_REGION)
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (PS.CUSTOMER_ID) ADDRESS,
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
                  AND PS.ORG_ID = :P_ORG_ID
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR PS.CUSTOMER_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO)
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND (:P_REGION IS NULL OR XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) = :P_REGION)
         GROUP BY PS.ORG_ID, PS.CUSTOMER_ID)
  SELECT REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS,
         SUM (OPEN_BALANCE) OPEN_BALANCE,
         SUM (DR_AMOUNT) DR_AMOUNT,
         SUM (CR_AMOUNT) CR_AMOUNT
    FROM XX_CUSTOMER_SUMMARY_TAB
GROUP BY REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS
ORDER BY 1


------------------------------Updated with APPS--------------------------------------------
WITH XX_CUSTOMER_SUMMARY_TAB
     AS (  SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (CB.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CB.CUSTOMER_ID) ADDRESS,
                  NVL (SUM (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0)), 0) OPEN_BALANCE,
                  0 DR_AMOUNT,
                  0 CR_AMOUNT
             FROM APPS.XXAKG_AR_CUSTOMER_LEDGER_V CB
            WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR CUSTOMER_ID >= :P_CUSTOMER_ID_FROM)
                  AND (:P_CUSTOMER_ID_TO IS NULL OR CUSTOMER_ID <= :P_CUSTOMER_ID_TO)
                  AND GL_DATE < :P_DATE_FROM
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (CB.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE CB.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY CUSTOMER_ID
         UNION ALL
           SELECT APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) REGION,
                  CUSTOMER_ID,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_WITH_NUMBER (PS.CUSTOMER_ID) CUSTOMER,
                  APPS.XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (PS.CUSTOMER_ID) ADDRESS,
                  0 OPEN_BALANCE,
                  SUM (GREATEST (PS.AMOUNT_DUE_ORIGINAL, 0)) DR_AMOUNT,
                  (0 - SUM (LEAST (PS.AMOUNT_DUE_ORIGINAL, 0))) CR_AMOUNT
             FROM APPS.XXAKG_AR_PAYMENT_SCHEDULES_V PS
            WHERE     NOT EXISTS
                             (SELECT 1
                                FROM APPS.AR_CASH_RECEIPTS_ALL CR
                               WHERE     PS.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                                     AND PS.ORG_ID = CR.ORG_ID
                                     AND NVL (CR.STATUS, 'AKG') IN ('CCRR', 'CC_CHARGEBACK_REV', 'NSF', 'REV', 'STOP'))
                  AND PS.ORG_ID = :P_ORG_ID
                  AND (:P_CUSTOMER_ID_FROM IS NULL OR PS.CUSTOMER_ID BETWEEN :P_CUSTOMER_ID_FROM AND :P_CUSTOMER_ID_TO)
                  AND PS.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                  AND (:P_REGION IS NULL OR APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (PS.CUSTOMER_ID) = :P_REGION)
                  AND EXISTS(SELECT 1 FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE PS.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID AND (:P_CUSTOMER_STATUS IS NULL OR (HCA.STATUS = :P_CUSTOMER_STATUS)))
         GROUP BY PS.ORG_ID, PS.CUSTOMER_ID)
  SELECT REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS,
         SUM (OPEN_BALANCE) OPEN_BALANCE,
         SUM (DR_AMOUNT) DR_AMOUNT,
         SUM (CR_AMOUNT) CR_AMOUNT
    FROM APPS.XX_CUSTOMER_SUMMARY_TAB
GROUP BY REGION,
         CUSTOMER_ID,
         CUSTOMER,
         ADDRESS
ORDER BY 1


------------------------------*******************-----------------------------------
--OR (HCA.STATUS = DECODE(:P_CUSTOMER_STATUS,'Active','A','Inactive','I'))))