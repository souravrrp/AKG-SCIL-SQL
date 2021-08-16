SELECT CUSTOMER_NUMBER,
       CUSTOMER_NAME,
       ADDRESS,
       OPENING_BALANCE,
       --(SALES_AMOUNT-GET_EXTRA_AR_AMT) SALES_AMOUNT,  --commented by safat: GET_EXTRA_AR_AMT is not required which subtracting the order value of those were created before the parameter P_FROM_DATE but delivered within the parameter date
       SALES_AMOUNT,
       RECEIVED_AMOUNT,
       ADJUSTMENT_AMOUNT ADJUSTMENT_AMOUNT_ACTUAL,
       WAITING_4_SHIPPED_QTY,
       WAITING_4_SHIPPED_AMT
  FROM (SELECT XXAKG_AR_PKG.GET_CUST_OPENING_BALANCE (CUST.CUSTOMER_ID,
                                                      CUST.ORG_ID,
                                                      :P_DATE_FROM)
                  OPENING_BALANCE,
               XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED(CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'AMOUNT',
                                                      :P_DATE_FROM - 1)
               PENDING_SALES_AMOUNT,
               CUST.CUSTOMER_NUMBER,
               CUST.CUSTOMER_NAME,
               DECODE (CUST.ADDRESS2,
                       NULL, CUST.ADDRESS1,
                       CUST.ADDRESS1 || ',' || CUST.ADDRESS2)
                  ADDRESS,
               (XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG (CUST.CUSTOMER_ID,
                                                         CUST.ORG_ID,
                                                         :P_DATE_FROM,
                                                         :P_DATE_TO)
                /*+ GET_CUST_SALES_AMOUNT_N (CUST.ORG_ID,
                                CUST.CUSTOMER_ID,
                                :P_DATE_FROM,
                                :P_DATE_TO) */  --Commented by Safat due to complexity of the code and may not needed for RMC
               --safat:: need to incorporate following logic in package function XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG
           --following logic consider the negetive amount i.e. discount lines of invoice, as all positive lines are already considered in the above functions XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG
           -- it is not required to consider the return order lines as those balances are considered through payment schedule type DM,CM
                   +NVL((SELECT SUM (ACCTD_AMOUNT) AMOUNT
                   FROM RA_CUSTOMER_TRX_ALL TRXH,
                        RA_CUSTOMER_TRX_LINES_ALL TRXL,
                        RA_CUST_TRX_LINE_GL_DIST_ALL DST,
                        RA_CUST_TRX_TYPES_ALL TP,
                        RA_BATCH_SOURCES_ALL BAT
                  WHERE   TRXH.CUSTOMER_TRX_ID = TRXL.CUSTOMER_TRX_ID
                        AND TRXH.CUST_TRX_TYPE_ID=TP.CUST_TRX_TYPE_ID
                        AND TRXH.ORG_ID=TP.ORG_ID
                        AND TRXH.BATCH_SOURCE_ID=BAT.BATCH_SOURCE_ID
                        AND TRXH.ORG_ID=BAT.ORG_ID
                        AND TRXL.CUSTOMER_TRX_ID = DST.CUSTOMER_TRX_ID
                        AND TRXL.CUSTOMER_TRX_LINE_ID=DST.CUSTOMER_TRX_LINE_ID                        
                        AND TRXL.INTERFACE_LINE_CONTEXT = 'ORDER ENTRY'
                        AND TO_NUMBER(NVL(TRXL.INTERFACE_LINE_ATTRIBUTE11,0)) !=0                        
                        AND TRXH.BILL_TO_CUSTOMER_ID = CUST.CUSTOMER_ID
                        AND TRXH.ORG_ID = CUST.ORG_ID
                        AND DST.ACCOUNT_CLASS = 'REV'
                        AND DST.AMOUNT <0
                        AND DST.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                        AND TP.TYPE='INV'
                        AND BAT.NAME='ORDER_ENTRY'),0)             
                  ) SALES_AMOUNT,
                 GET_EXTRA_AR_AMT_DATERANGE( 
                                        CUST.ORG_ID,
                                        CUST.CUSTOMER_ID,
                                        :P_DATE_FROM,
                                        :P_DATE_TO) 
                                        GET_EXTRA_AR_AMT,
               XXAKG_AR_PKG.GET_REMITTED_RECEIPT (CUST.CUSTOMER_ID,
                                                  CUST.ORG_ID,
                                                  :P_DATE_FROM,
                                                  :P_DATE_TO)
                  RECEIVED_AMOUNT,
               (GET_CUSTOMER_REFUND (CUST.ORG_ID,
                           CUST.CUSTOMER_ID,
                            :P_DATE_FROM,
                          :P_DATE_TO)
                + (XXAKG_AR_PKG.GET_CUST_CREDIT_DEBIT_TOTAL (
                      CUST.CUSTOMER_ID,
                      CUST.ORG_ID,
                      :P_DATE_FROM,
                      :P_DATE_TO)))
                  ADJUSTMENT_AMOUNT,
              XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED(CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'QUANTITY',
                                                      :P_DATE_TO)
                  WAITING_4_SHIPPED_QTY,
               XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED (CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'AMOUNT',
                                                      :P_DATE_TO)
                  WAITING_4_SHIPPED_AMT
               FROM XXAKG_AR_CUSTOMER_SITE_V CUST, XXAKG_DISTRIBUTOR_BLOCK_M DBM
               WHERE CUST.SITE_USE_CODE = 'BILL_TO'
               AND CUST.PRIMARY_FLAG = 'Y'
               AND CUST.CUSTOMER_ID = DBM.CUSTOMER_ID(+)
               AND CUST.ORG_ID = DBM.ORG_ID(+)
               AND cust.ORG_ID = :P_ORG_ID
               AND (:P_CUSTOMER_ID IS NULL OR CUST.CUSTOMER_ID = :P_CUSTOMER_ID)
               AND (:P_REGION IS NULL OR DBM.REGION_NAME = :P_REGION)
               AND (:P_CUSTOMER_STATUS IS NULL OR CUST.STATUS = :P_CUSTOMER_STATUS)
               AND EXISTS(SELECT 1 FROM APPS.XXAKG_DISTRIBUTOR_BLOCK_D DBD,APPS.XXAKG_RETAILERS_CELL_D CELL 
               WHERE DBM.ORG_ID = DBD.ORG_ID AND DBM.HEADER_ID = DBD.HEADER_ID AND DBD.LINE_ID = CELL.LINE_ID
               AND TRUNC (SYSDATE) BETWEEN CELL.START_DATE_ACTIVE AND NVL (CELL.END_DATE_ACTIVE, TRUNC (SYSDATE))
               AND (:P_CELL_NAME IS NULL OR CELL.CELL_NAME = :P_CELL_NAME)))
order by CUSTOMER_NUMBER


-------------------------Old_30_APR_2019----------------------------------------
SELECT CUSTOMER_NUMBER,
       CUSTOMER_NAME,
       ADDRESS,
       OPENING_BALANCE,
       --(SALES_AMOUNT-GET_EXTRA_AR_AMT) SALES_AMOUNT,  --commented by safat: GET_EXTRA_AR_AMT is not required which subtracting the order value of those were created before the parameter P_FROM_DATE but delivered within the parameter date
       SALES_AMOUNT,
       RECEIVED_AMOUNT,
       ADJUSTMENT_AMOUNT ADJUSTMENT_AMOUNT_ACTUAL,
       WAITING_4_SHIPPED_QTY,
       WAITING_4_SHIPPED_AMT
  FROM (SELECT XXAKG_AR_PKG.GET_CUST_OPENING_BALANCE (CUST.CUSTOMER_ID,
                                                      CUST.ORG_ID,
                                                      :P_DATE_FROM)
                  OPENING_BALANCE,
               XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED(CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'AMOUNT',
                                                      :P_DATE_FROM - 1)
               PENDING_SALES_AMOUNT,
               CUST.CUSTOMER_NUMBER,
               CUST.CUSTOMER_NAME,
               DECODE (CUST.ADDRESS2,
                       NULL, CUST.ADDRESS1,
                       CUST.ADDRESS1 || ',' || CUST.ADDRESS2)
                  ADDRESS,
               (XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG (CUST.CUSTOMER_ID,
                                                         CUST.ORG_ID,
                                                         :P_DATE_FROM,
                                                         :P_DATE_TO)
                /*+ GET_CUST_SALES_AMOUNT_N (CUST.ORG_ID,
                                CUST.CUSTOMER_ID,
                                :P_DATE_FROM,
                                :P_DATE_TO) */  --Commented by Safat due to complexity of the code and may not needed for RMC
               --safat:: need to incorporate following logic in package function XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG
           --following logic consider the negetive amount i.e. discount lines of invoice, as all positive lines are already considered in the above functions XXAKG_AR_PKG.GET_CUS_AR_BALANCE_DATERAG
           -- it is not required to consider the return order lines as those balances are considered through payment schedule type DM,CM
                   +NVL((SELECT SUM (ACCTD_AMOUNT) AMOUNT
                   FROM RA_CUSTOMER_TRX_ALL TRXH,
                        RA_CUSTOMER_TRX_LINES_ALL TRXL,
                        RA_CUST_TRX_LINE_GL_DIST_ALL DST,
                        RA_CUST_TRX_TYPES_ALL TP,
                        RA_BATCH_SOURCES_ALL BAT
                  WHERE   TRXH.CUSTOMER_TRX_ID = TRXL.CUSTOMER_TRX_ID
                        AND TRXH.CUST_TRX_TYPE_ID=TP.CUST_TRX_TYPE_ID
                        AND TRXH.ORG_ID=TP.ORG_ID
                        AND TRXH.BATCH_SOURCE_ID=BAT.BATCH_SOURCE_ID
                        AND TRXH.ORG_ID=BAT.ORG_ID
                        AND TRXL.CUSTOMER_TRX_ID = DST.CUSTOMER_TRX_ID
                        AND TRXL.CUSTOMER_TRX_LINE_ID=DST.CUSTOMER_TRX_LINE_ID                        
                        AND TRXL.INTERFACE_LINE_CONTEXT = 'ORDER ENTRY'
                        AND TO_NUMBER(NVL(TRXL.INTERFACE_LINE_ATTRIBUTE11,0)) !=0                        
                        AND TRXH.BILL_TO_CUSTOMER_ID = CUST.CUSTOMER_ID
                        AND TRXH.ORG_ID = CUST.ORG_ID
                        AND DST.ACCOUNT_CLASS = 'REV'
                        AND DST.AMOUNT <0
                        AND DST.GL_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
                        AND TP.TYPE='INV'
                        AND BAT.NAME='ORDER_ENTRY'),0)             
                  ) SALES_AMOUNT,
                 GET_EXTRA_AR_AMT_DATERANGE( 
                                        CUST.ORG_ID,
                                        CUST.CUSTOMER_ID,
                                        :P_DATE_FROM,
                                        :P_DATE_TO) 
                                        GET_EXTRA_AR_AMT,
               XXAKG_AR_PKG.GET_REMITTED_RECEIPT (CUST.CUSTOMER_ID,
                                                  CUST.ORG_ID,
                                                  :P_DATE_FROM,
                                                  :P_DATE_TO)
                  RECEIVED_AMOUNT,
               (GET_CUSTOMER_REFUND (CUST.ORG_ID,
                           CUST.CUSTOMER_ID,
                            :P_DATE_FROM,
                          :P_DATE_TO)
                + (XXAKG_AR_PKG.GET_CUST_CREDIT_DEBIT_TOTAL (
                      CUST.CUSTOMER_ID,
                      CUST.ORG_ID,
                      :P_DATE_FROM,
                      :P_DATE_TO)))
                  ADJUSTMENT_AMOUNT,
              XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED(CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'QUANTITY',
                                                      :P_DATE_TO)
                  WAITING_4_SHIPPED_QTY,
               XXAKG_ONT_PKG.GET_WAITING_FOR_SHIPPED (CUST.ORG_ID,
                                                      CUST.CUSTOMER_ID,
                                                      'AMOUNT',
                                                      :P_DATE_TO)
                  WAITING_4_SHIPPED_AMT
          FROM XXAKG_AR_CUSTOMER_SITE_V CUST, XXAKG_DISTRIBUTOR_BLOCK_M DBM
         WHERE     CUST.SITE_USE_CODE = 'BILL_TO'
               AND CUST.PRIMARY_FLAG = 'Y'
               AND CUST.CUSTOMER_ID = DBM.CUSTOMER_ID(+)
               AND CUST.ORG_ID = DBM.ORG_ID(+)
               AND cust.ORG_ID = :P_ORG_ID
               AND (:P_CUSTOMER_ID IS NULL 
                OR CUST.CUSTOMER_ID = :P_CUSTOMER_ID)
               AND (:P_REGION IS NULL OR DBM.REGION_NAME = :P_REGION)
               AND (:P_CUSTOMER_STATUS IS NULL 
                 OR CUST.STATUS = :P_CUSTOMER_STATUS))
order by CUSTOMER_NUMBER

--------------------------------------------------------------------------------
SELECT
CUST.CUSTOMER_NUMBER
,DBM.REGION_NAME
,DBD.BLOCK_NAME
,CELL.CELL_NAME
FROM APPS.XXAKG_AR_CUSTOMER_SITE_V CUST,APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM ,APPS.XXAKG_DISTRIBUTOR_BLOCK_D DBD,APPS.XXAKG_RETAILERS_CELL_D CELL
         WHERE 1=1
               AND CUST.SITE_USE_CODE = 'BILL_TO'
               AND CUST.PRIMARY_FLAG = 'Y'
               AND CUST.CUSTOMER_ID = DBM.CUSTOMER_ID(+)
               AND TRUNC (SYSDATE) BETWEEN CELL.START_DATE_ACTIVE AND NVL (CELL.END_DATE_ACTIVE, TRUNC (SYSDATE))
               AND CUST.ORG_ID = DBM.ORG_ID(+)
               AND CUST.ORG_ID = 84
--               AND (:P_CUSTOMER_ID IS NULL OR CUST.CUSTOMER_ID = :P_CUSTOMER_ID)
--               AND (:P_REGION IS NULL OR DBM.REGION_NAME = :P_REGION)
--               AND (:P_CELL_NAME IS NULL OR CELL.CELL_NAME = :P_CELL_NAME)
--               AND (:P_CUSTOMER_STATUS IS NULL OR CUST.STATUS = :P_CUSTOMER_STATUS)
               AND DBM.HEADER_ID = DBD.HEADER_ID
               AND DBM.ORG_ID = DBD.ORG_ID
               AND DBD.LINE_ID = CELL.LINE_ID