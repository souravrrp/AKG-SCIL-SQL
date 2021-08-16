/* Formatted on 7/19/2017 3:48:14 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PROCEDURE APPS.xxakg_distribution_cost_proc (
   ERRBUF             OUT NOCOPY VARCHAR2,
   RETCODE            OUT NOCOPY NUMBER,
   PP_DATE_FROM                  VARCHAR2,
   PP_DATE_TO                    VARCHAR2,
   p_data_source                 VARCHAR2 DEFAULT NULL)
AS
   P_DATE_FROM   DATE := TO_DATE (pp_date_from, 'RRRR/MM/DD  HH24:MI:SS');
   P_DATE_TO     DATE := TO_DATE (pp_date_to, 'RRRR/MM/DD  HH24:MI:SS');
--P_DATE_FROM     DATE := '01-NOV-2012';
--P_DATE_TO     DATE := '30-NOV-2012';

/*
DECLARE
        ERRBUF        varchar2(1000);
    RETCODE        number;

BEGIN
    xxakg_distribution_cost_proc_n(ERRBUF, RETCODE, '01-NOV-2012', '30-NOV-2012', null);
END;
*/

BEGIN
   DELETE XXAKG_DIST_COST_MOV_TEMP;

   INSERT INTO XXAKG_DIST_COST_MOV_TEMP
      SELECT *
        FROM XXAKG_DIST_COST_MOV_V
       WHERE TRUNC (ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM AND P_DATE_TO;

   --Start Population of Mov Data which are transfered from Factory to Customer Site
   IF NVL (p_data_source, 'SCI-CUST') = 'SCI-CUST'
   THEN
      DELETE XXAKG_DISTRIBUTION_COST
       WHERE TRUNC (ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM AND P_DATE_TO
             AND DATA_SOURCE = 'SCI-CUST';

      DECLARE
         CURSOR cur (
            L_DATE_FROM    DATE,
            L_DATE_TO      DATE)
         IS
              SELECT MOV.ORG_ID,
                     MOV.CUSTOMER_ID,
                     MOV.HEADER_ID,
                     MOV.ORDER_NUMBER,
                     MOV.LINE_ID,
                     MOV.INVENTORY_ITEM_ID,
                     MOV.SHIP_TO_ORG_ID,
                     MOV.WAREHOUSE_ID,
                     MOV.TYPE,
                     MOV.WAREHOUSE_NAME,
                     TO_CHAR (MOV.ACTUAL_SHIPMENT_DATE, 'MMYYYY') MMYYORD,
                     MOV.PERIOD_NAME,
                     DECODE (
                        MOV.INVENTORY_ITEM_ID,
                        24408, (MOV.SHIPPED_QUANTITY
                                * XXAKG_ONT_PKG.GET_BULK_CONVERSION),
                        206570, (MOV.SHIPPED_QUANTITY
                                 * XXAKG_ONT_PKG.GET_BULK_CONVERSION) --add safat for OPC BULK
                                                                     ,
                        MOV.SHIPPED_QUANTITY)
                        SHIPPED_QUANTITY,
                     MOV.SHIPPED_QUANTITY SHIPPED_QUANTITY_ORGINAL,
                     MOV.TRANSPORT_MODE,
                     MOV.ACTUAL_SHIPMENT_DATE,
                     API.GL_DATE,
                     MOV.HIRE_RATE_AP,
                     MOV.DO_HDR_ID,
                     MOV.DO_NUMBER,
                     MOV.MOV_ORD_HDR_ID,
                     MOV.MOV_ORDER_NO,
                     MOV.FINAL_DESTINATION,
                     'SCI-CUST' DATA_SOURCE
                FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
               WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                     AND MoV.ORG_ID = API.ORG_ID
                     --         AND MOV.PERIOD_NAME = TO_CHAR(API.GL_DATE, 'MON-YYYY')
                     AND API.CANCELLED_DATE IS NULL
                     AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN L_DATE_FROM
                                                              AND L_DATE_TO
                     AND MOV.TRANSPORT_MODE NOT IN
                            ('Barge Ex factory', 'Ex factory truck')
                     AND MOV.TYPE = 'FACTORY'
                     AND MOV.ORG_ID = 85
            ORDER BY MMYYORD, TRANSPORT_MODE, HEADER_ID;

         -- Pick up all periods within a date range
         CURSOR periodcur
         IS
            SELECT DISTINCT period_name, start_date, end_date
              FROM gl_period_statuses
             WHERE     application_id = 101
                   AND ADJUSTMENT_PERIOD_FLAG = 'N'
                   AND start_date >= TRUNC (p_date_from, 'MONTH')
                   AND end_date <= LAST_DAY (TRUNC (p_date_to, 'MONTH'));

         CURSOR other_tripcost_cur (
            P_PERIOD_NAME    VARCHAR2,
            P_COMPANY        VARCHAR2,
            P_COST_CENTER    VARCHAR2,
            P_ACCOUNT        VARCHAR2)
         IS
            --Account Balance excluding Payables

            SELECT SUM (
                      NVL (GJL.ACCOUNTED_DR, 0) - NVL (GJL.ACCOUNTED_CR, 0))
                      BALANCE
              FROM GL_JE_HEADERS GJH,
                   GL_JE_LINES GJL,
                   GL_CODE_COMBINATIONS CC
             WHERE     GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
                   AND GJL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
                   AND GJH.LEDGER_ID = 2025
                   AND (NVL (GJL.ACCOUNTED_DR, 0) <> 0
                        OR NVL (GJL.ACCOUNTED_CR, 0) <> 0)
                   AND GJH.JE_SOURCE <> 'Payables'
                   AND GJL.STATUS = 'P'
                   AND GJH.ACTUAL_FLAG = 'A'
                   AND GJL.PERIOD_NAME = P_PERIOD_NAME
                   AND CC.SEGMENT1 = P_COMPANY
                   AND CC.SEGMENT2 = P_COST_CENTER
                   AND CC.SEGMENT3 = P_ACCOUNT
            UNION ALL                 -- AP Invoice which has created manually
            SELECT SUM (
                      NVL (GJL.ACCOUNTED_DR, 0) - NVL (GJL.ACCOUNTED_CR, 0))
                      BALANCE
              FROM AP_INVOICES_ALL API,
                   XLA.XLA_TRANSACTION_ENTITIES XTE,
                   XLA_AE_HEADERS XAH,
                   XLA_AE_LINES XAL,
                   GL_IMPORT_REFERENCES GIR,
                   GL_JE_HEADERS GJH,
                   GL_JE_LINES GJL,
                   GL_CODE_COMBINATIONS CC
             WHERE     API.INVOICE_ID = XTE.SOURCE_ID_INT_1
                   AND XTE.ENTITY_ID = XAH.ENTITY_ID
                   AND XTE.ENTITY_CODE = 'AP_INVOICES'
                   AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
                   AND XAH.APPLICATION_ID = 200
                   AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
                   AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
                   AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
                   AND GIR.GL_SL_LINK_TABLE IN ('APECL', 'XLAJEL')
                   AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
                   AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
                   AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0
                        OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
                   AND XAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
                   AND GJH.ACTUAL_FLAG = 'A'
                   AND GJL.STATUS = 'P'
                   AND API.SOURCE <> 'AKG TRIP INVOICE'
                   AND GJL.PERIOD_NAME = P_PERIOD_NAME
                   AND CC.SEGMENT1 = P_COMPANY
                   AND CC.SEGMENT2 = P_COST_CENTER
                   AND CC.SEGMENT3 = P_ACCOUNT;

         V_UNIT_DIST_COST              NUMBER;
         V_ACCOUNT                     VARCHAR2 (10);
         V_TOTAL_TRIP_COST_OTHER       NUMBER;
         V_TRNSWISE_SHIPPED_QUANTITY   NUMBER;
         V_UNIT_DIST_COST_OTHER        NUMBER;
         V_PREV_TRANSPORT_MODE         VARCHAR2 (50);
      BEGIN
         FOR periodrec IN periodcur
         LOOP                                             -- Start Period Loop
            FOR rec IN cur (periodrec.start_date, periodrec.end_date)
            LOOP
               IF rec.TRANSPORT_MODE <> NVL (V_PREV_TRANSPORT_MODE, 'X')
               THEN
                  V_TOTAL_TRIP_COST_OTHER := 0;
                  V_TRNSWISE_SHIPPED_QUANTITY := 0;
                  V_TRNSWISE_SHIPPED_QUANTITY := 0;

                  IF REC.TRANSPORT_MODE IN
                        ('Company Truck',
                         'Company Bulk Carrier',
                         'Company Trailer')
                  THEN
                     V_ACCOUNT := '4031901';  --Own Truck hire charges-Factory

                     FOR other_tripcost_rec
                        IN other_tripcost_cur (periodrec.period_name,
                                               '2110',
                                               'DIST',
                                               V_ACCOUNT)
                     LOOP
                        V_TOTAL_TRIP_COST_OTHER :=
                           NVL (V_TOTAL_TRIP_COST_OTHER, 0)
                           + NVL (other_tripcost_rec.balance, 0);
                     END LOOP;

                     SELECT SUM (SHIPPED_QUANTITY)
                       INTO V_TRNSWISE_SHIPPED_QUANTITY
                       FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
                      WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                            AND MoV.ORG_ID = API.ORG_ID
                            AND API.CANCELLED_DATE IS NULL
                            AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN periodrec.start_date
                                                                     AND periodrec.end_date
                            AND MOV.TRANSPORT_MODE IN
                                   ('Company Truck',
                                    'Company Bulk Carrier',
                                    'Company Trailer')
                            AND MOV.TYPE = 'FACTORY'
                            AND MOV.ORG_ID = 85;

                     IF NVL (V_TOTAL_TRIP_COST_OTHER, 0) <> 0
                     THEN
                        V_UNIT_DIST_COST_OTHER :=
                           ROUND (
                              V_TOTAL_TRIP_COST_OTHER
                              / V_TRNSWISE_SHIPPED_QUANTITY,
                              5);
                     END IF;
                  ELSIF rec.TRANSPORT_MODE IN ('Company Barge')
                  THEN
                     V_ACCOUNT := '4031903';          --Own Barge hire charges

                     FOR other_tripcost_rec
                        IN other_tripcost_cur (periodrec.period_name,
                                               '2110',
                                               'DIST',
                                               V_ACCOUNT)
                     LOOP
                        V_TOTAL_TRIP_COST_OTHER :=
                           NVL (V_TOTAL_TRIP_COST_OTHER, 0)
                           + NVL (other_tripcost_rec.balance, 0);
                     END LOOP;

                     SELECT SUM (SHIPPED_QUANTITY)
                       INTO V_TRNSWISE_SHIPPED_QUANTITY
                       FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
                      WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                            AND MoV.ORG_ID = API.ORG_ID
                            AND API.CANCELLED_DATE IS NULL
                            AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN periodrec.start_date
                                                                     AND periodrec.end_date
                            AND MOV.TRANSPORT_MODE IN ('Company Barge')
                            AND MOV.TYPE = 'FACTORY'
                            AND MOV.ORG_ID = 85;

                     IF NVL (V_TOTAL_TRIP_COST_OTHER, 0) <> 0
                     THEN
                        V_UNIT_DIST_COST_OTHER :=
                           ROUND (
                              V_TOTAL_TRIP_COST_OTHER
                              / V_TRNSWISE_SHIPPED_QUANTITY,
                              5);
                     END IF;
                  ELSIF rec.TRANSPORT_MODE IN
                           ('Rental Truck', 'Rental Trailer')
                  THEN
                     V_ACCOUNT := '4031804';    --Rental Truck Charges-Factory

                     FOR other_tripcost_rec
                        IN other_tripcost_cur (periodrec.period_name,
                                               '2110',
                                               'DIST',
                                               V_ACCOUNT)
                     LOOP
                        V_TOTAL_TRIP_COST_OTHER :=
                           NVL (V_TOTAL_TRIP_COST_OTHER, 0)
                           + NVL (other_tripcost_rec.balance, 0);
                     END LOOP;

                     SELECT SUM (SHIPPED_QUANTITY)
                       INTO V_TRNSWISE_SHIPPED_QUANTITY
                       FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
                      WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                            AND MoV.ORG_ID = API.ORG_ID
                            AND API.CANCELLED_DATE IS NULL
                            AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN periodrec.start_date
                                                                     AND periodrec.end_date
                            AND MOV.TRANSPORT_MODE IN
                                   ('Rental Truck', 'Rental Trailer')
                            AND MOV.TYPE = 'FACTORY'
                            AND MOV.ORG_ID = 85;

                     IF NVL (V_TOTAL_TRIP_COST_OTHER, 0) <> 0
                     THEN
                        V_UNIT_DIST_COST_OTHER :=
                           ROUND (
                              V_TOTAL_TRIP_COST_OTHER
                              / V_TRNSWISE_SHIPPED_QUANTITY,
                              5);
                     END IF;
                  ELSIF rec.TRANSPORT_MODE IN ('Rental Barge')
                  THEN
                     V_ACCOUNT := '4031808';       --Rental Barge Hire Charges

                     FOR other_tripcost_rec
                        IN other_tripcost_cur (periodrec.period_name,
                                               '2110',
                                               'DIST',
                                               V_ACCOUNT)
                     LOOP
                        V_TOTAL_TRIP_COST_OTHER :=
                           NVL (V_TOTAL_TRIP_COST_OTHER, 0)
                           + NVL (other_tripcost_rec.balance, 0);
                     END LOOP;

                     SELECT SUM (SHIPPED_QUANTITY)
                       INTO V_TRNSWISE_SHIPPED_QUANTITY
                       FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
                      WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                            AND MoV.ORG_ID = API.ORG_ID
                            AND API.CANCELLED_DATE IS NULL
                            AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN periodrec.start_date
                                                                     AND periodrec.end_date
                            AND MOV.TRANSPORT_MODE IN ('Rental Barge')
                            AND MOV.TYPE = 'FACTORY'
                            AND MOV.ORG_ID = 85;

                     IF NVL (V_TOTAL_TRIP_COST_OTHER, 0) <> 0
                     THEN
                        V_UNIT_DIST_COST_OTHER :=
                           ROUND (
                              V_TOTAL_TRIP_COST_OTHER
                              / V_TRNSWISE_SHIPPED_QUANTITY,
                              5);
                     END IF;
                  END IF;
               END IF;                              -- Transport Mode Checking

               V_UNIT_DIST_COST :=
                  XXAKG_GET_UNIT_DIST_COST (rec.MOV_ORDER_NO, 'DO');

               INSERT
                 INTO XXAKG_DISTRIBUTION_COST (ORG_ID,
                                               CUSTOMER_ID,
                                               HEADER_ID,
                                               ORDER_NUMBER,
                                               LINE_ID,
                                               inventory_item_id,
                                               FROM_WAREHOUSE_ID,
                                               TO_WAREHOUSE_ID,
                                               SHIP_TO_ORG_ID,
                                               ORAGANIZATION_NAME,
                                               SHIPPED_QUANTITY,
                                               FACTORY_GHAT,
                                               TRANSPORT_MODE,
                                               ACTUAL_SHIPMENT_DATE,
                                               INVOICE_GL_DATE,
                                               HIRE_RATE,
                                               UNIT_GHAT_COST,
                                               TOTAL_GHAT_AMOUNT,
                                               UNIT_TO_COST,
                                               TOTAL_TO_AMOUNT,
                                               UNIT_DIST_COST,
                                               DIST_AMOUNT,
                                               ACTUAL_UNIT_DIST_COST,
                                               ACTUAL_DIST_AMOUNT,
                                               DO_HEADER_ID,
                                               DO_NUMBER,
                                               MOV_HEADER_ID,
                                               MOV_ORDER_NO,
                                               FINAL_DESTINATION,
                                               DATA_SOURCE,
                                               UNIT_DIST_COST_OTHER_RECON,
                                               TRNSWISE_SHIPPED_QTY_RECON,
                                               TOTAL_TRIP_COST_OTHER_RECON,
                                               CREATION_DATE,
                                               CREATED_BY,
                                               LAST_UPDATE_DATE,
                                               LAST_UPDATED_BY)
               VALUES (
                         REC.ORG_ID,
                         REC.CUSTOMER_ID,
                         REC.HEADER_ID,
                         REC.ORDER_NUMBER,
                         REC.LINE_ID,
                         REC.inventory_item_id,
                         REC.WAREHOUSE_ID,
                         NULL,
                         REC.SHIP_TO_ORG_ID,
                         REC.WAREHOUSE_NAME,
                         REC.SHIPPED_QUANTITY,
                         REC.TYPE,
                         REC.TRANSPORT_MODE,
                         REC.ACTUAL_SHIPMENT_DATE,
                         REC.GL_DATE,
                         REC.HIRE_RATE_AP,
                         0,
                         0,
                         0,
                         0,
                         --(NVL(V_UNIT_DIST_COST,0)+NVL(V_UNIT_DIST_COST_OTHER,0)), ROUND((NVL(V_UNIT_DIST_COST,0)+NVL(V_UNIT_DIST_COST_OTHER,0))*REC.SHIPPED_QUANTITY_ORGINAL, 2),
                         (NVL (V_UNIT_DIST_COST, 0)),
                         ROUND (
                            (NVL (V_UNIT_DIST_COST, 0))
                            * REC.SHIPPED_QUANTITY_ORGINAL,
                            2),
                         (NVL (V_UNIT_DIST_COST, 0)
                          + NVL (V_UNIT_DIST_COST_OTHER, 0)),
                         ROUND (
                            (NVL (V_UNIT_DIST_COST, 0)
                             + NVL (V_UNIT_DIST_COST_OTHER, 0))
                            * REC.SHIPPED_QUANTITY_ORGINAL,
                            2),
                         REC.DO_HDR_ID,
                         REC.DO_NUMBER,
                         REC.MOV_ORD_HDR_ID,
                         REC.MOV_ORDER_NO,
                         REC.FINAL_DESTINATION,
                         REC.DATA_SOURCE,
                         V_UNIT_DIST_COST_OTHER,
                         V_TRNSWISE_SHIPPED_QUANTITY,
                         V_TOTAL_TRIP_COST_OTHER,
                         SYSDATE,
                         0,
                         SYSDATE,
                         0);

               V_PREV_TRANSPORT_MODE := rec.TRANSPORT_MODE;
            END LOOP;                                           -- Main Cursor
         END LOOP;                                          -- End Period Loop
      END;
   END IF; --End Population of Mov Data which are transfered from Factory to Customer Site

   COMMIT;

   --Start Population of Mov Data which are transfered from Factory to Customer Site by Customer own cost
   IF NVL (p_data_source, 'SCI-CUST-EX') = 'SCI-CUST-EX'
   THEN
      DELETE XXAKG_DISTRIBUTION_COST
       WHERE TRUNC (ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM AND P_DATE_TO
             AND DATA_SOURCE = 'SCI-CUST-EX';

      BEGIN
         INSERT INTO XXAKG_DISTRIBUTION_COST (ORG_ID,
                                              CUSTOMER_ID,
                                              HEADER_ID,
                                              ORDER_NUMBER,
                                              LINE_ID,
                                              inventory_item_id,
                                              FROM_WAREHOUSE_ID,
                                              TO_WAREHOUSE_ID,
                                              SHIP_TO_ORG_ID,
                                              ORAGANIZATION_NAME,
                                              SHIPPED_QUANTITY,
                                              FACTORY_GHAT,
                                              TRANSPORT_MODE,
                                              ACTUAL_SHIPMENT_DATE,
                                              INVOICE_GL_DATE,
                                              HIRE_RATE,
                                              UNIT_GHAT_COST,
                                              TOTAL_GHAT_AMOUNT,
                                              UNIT_TO_COST,
                                              TOTAL_TO_AMOUNT,
                                              UNIT_DIST_COST,
                                              DIST_AMOUNT,
                                              ACTUAL_UNIT_DIST_COST,
                                              ACTUAL_DIST_AMOUNT,
                                              DO_HEADER_ID,
                                              DO_NUMBER,
                                              MOV_HEADER_ID,
                                              MOV_ORDER_NO,
                                              FINAL_DESTINATION,
                                              DATA_SOURCE,
                                              CREATION_DATE,
                                              CREATED_BY,
                                              LAST_UPDATE_DATE,
                                              LAST_UPDATED_BY)
            SELECT MOV.ORG_ID,
                   MOV.CUSTOMER_ID,
                   MOV.HEADER_ID,
                   MOV.ORDER_NUMBER,
                   MOV.LINE_ID,
                   MOV.inventory_item_id,
                   MOV.WAREHOUSE_ID,
                   NULL,
                   MOV.SHIP_TO_ORG_ID,
                   MOV.WAREHOUSE_NAME,
                   DECODE (
                      MOV.INVENTORY_ITEM_ID,
                      24408, (MOV.SHIPPED_QUANTITY
                              * XXAKG_ONT_PKG.GET_BULK_CONVERSION),
                      206570, (MOV.SHIPPED_QUANTITY
                               * XXAKG_ONT_PKG.GET_BULK_CONVERSION) --add safat for OPC BULK
                                                                   ,
                      MOV.SHIPPED_QUANTITY),                    --24408 (Bulk)
                   MOV.TYPE,
                   MOV.TRANSPORT_MODE,
                   MOV.ACTUAL_SHIPMENT_DATE,
                   MOV.ACTUAL_SHIPMENT_DATE,
                   MOV.HIRE_RATE_AP,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   MOV.DO_HDR_ID,
                   MOV.DO_NUMBER,
                   MOV.MOV_ORD_HDR_ID,
                   MOV.MOV_ORDER_NO,
                   MOV.FINAL_DESTINATION,
                   'SCI-CUST-EX',
                   SYSDATE,
                   0,
                   SYSDATE,
                   0
              FROM XXAKG_DIST_COST_MOV_TEMP MOV
             WHERE MOV.TRANSPORT_MODE IN
                      ('Barge Ex factory', 'Ex factory truck')
                   AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM
                                                            AND P_DATE_TO
                   AND MOV.TYPE = 'FACTORY'
                   AND MOV.ORG_ID = 85;
      END;
   END IF; --End Population of Mov Data which are transfered from Factory to Customer Site by Customer own cost

   COMMIT;

   --Start Population of Mov Data which are transfered from Ghat to Customer Site
   IF NVL (p_data_source, 'GHAT-CUST') IN ('GHAT-CUST', 'GHAT-CUST-EX')
   THEN
      DELETE XXAKG_DISTRIBUTION_COST
       WHERE TRUNC (ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM AND P_DATE_TO
             AND DATA_SOURCE IN ('GHAT-CUST', 'GHAT-CUST-EX');

      DECLARE
         -- Pick up all Ghats
         CURSOR ghatcur
         IS
              SELECT organization_id warehouse_id, name warehouse_name
                FROM hr_all_organization_units
               WHERE TYPE = 'GHAT'
                     AND TRUNC (SYSDATE) BETWEEN TRUNC (date_from)
                                             AND NVL (date_to, TRUNC (SYSDATE))
            ORDER BY 1;

         -- Pick up all periods within a date range
         CURSOR periodcur
         IS
            SELECT DISTINCT period_name
              FROM gl_period_statuses
             WHERE     application_id = 101
                   AND ADJUSTMENT_PERIOD_FLAG = 'N'
                   AND start_date >= TRUNC (p_date_from, 'MONTH')
                   AND end_date <= LAST_DAY (TRUNC (p_date_to, 'MONTH'));

         -- Pick up Fixed Cost and Variable Cost for a Ghat
         CURSOR invcur (
            p_warehuse_id    NUMBER,
            P_PERIOD_NAME    VARCHAR2)
         IS
            SELECT SUM (NVL (accounted_dr, 0) - NVL (accounted_cr, 0)) amount
              FROM XXAKG_DIST_COST_GHAT_EXP_V
             WHERE warehouse_id = p_warehuse_id
                   AND period_name = P_PERIOD_NAME;

         -- Pick up Total TO Quantity and Cost for a Ghat
         CURSOR tocur (
            p_warehouse_id    NUMBER,
            P_PERIOD_NAME     VARCHAR2)
         IS                                                              -- TO
            SELECT SUM (invoice_amount) invoice_amount,
                   SUM (to_qunatity) to_qunatity
              FROM (  SELECT invoice_id,
                             invoice_num,
                             MAX (invoice_amount) invoice_amount,
                             SUM (to_qunatity) to_qunatity
                        FROM XXAKG_DIST_COST_TO_COST_V
                       WHERE     org_id = 85
                             AND to_warehouse_id = p_warehouse_id
                             AND period_name = P_PERIOD_NAME
                    GROUP BY invoice_id, invoice_num);

         --Pick up Mov order Data which are transfered from Ghat to Customer Site
         CURSOR cur (
            p_warehouse_id    NUMBER,
            P_PERIOD_NAME     VARCHAR2)
         IS
            SELECT MOV.ORG_ID,
                   MOV.CUSTOMER_ID,
                   MOV.HEADER_ID,
                   MOV.ORDER_NUMBER,
                   MOV.LINE_ID,
                   MOV.inventory_item_id,
                   MOV.SHIP_TO_ORG_ID,
                   MOV.WAREHOUSE_ID,
                   MOV.TYPE,
                   MOV.WAREHOUSE_NAME,
                   DECODE (
                      MOV.INVENTORY_ITEM_ID,
                      24408, (MOV.SHIPPED_QUANTITY
                              * XXAKG_ONT_PKG.GET_BULK_CONVERSION),
                      206570, (MOV.SHIPPED_QUANTITY
                               * XXAKG_ONT_PKG.GET_BULK_CONVERSION) --add safat for OPC BULK
                                                                   ,
                      MOV.SHIPPED_QUANTITY)
                      SHIPPED_QUANTITY,
                   MOV.SHIPPED_QUANTITY SHIPPED_QUANTITY_ORGINAL,
                   MOV.TRANSPORT_MODE,
                   MOV.ACTUAL_SHIPMENT_DATE,
                   API.GL_DATE,
                   MOV.HIRE_RATE_AP,
                   MOV.DO_HDR_ID,
                   MOV.DO_NUMBER,
                   MOV.MOV_ORD_HDR_ID,
                   MOV.MOV_ORDER_NO,
                   MOV.FINAL_DESTINATION,
                   'GHAT-CUST' DATA_SOURCE
              FROM XXAKG_DIST_COST_MOV_TEMP MOV, AP_INVOICES_ALL API
             WHERE     MOV.MOV_ORDER_NO = API.INVOICE_NUM
                   AND MoV.ORG_ID = API.ORG_ID
                   AND API.CANCELLED_DATE IS NULL
                   --           AND MOV.PERIOD_NAME = TO_CHAR(API.GL_DATE, 'MON-YYYY')
                   AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM
                                                            AND P_DATE_TO
                   AND MOV.PERIOD_NAME = P_PERIOD_NAME
                   AND MOV.WAREHOUSE_ID = p_warehouse_id
                   AND MOV.TYPE = 'GHAT'
                   AND MOV.ORG_ID = 85;

         --Pick up Mov order Data which are transfered from Ghat to Customer Site by customer own cost
         CURSOR excur (
            p_warehouse_id    NUMBER,
            P_PERIOD_NAME     VARCHAR2)
         IS
            SELECT MOV.ORG_ID,
                   MOV.CUSTOMER_ID,
                   MOV.HEADER_ID,
                   MOV.ORDER_NUMBER,
                   MOV.LINE_ID,
                   MOV.inventory_item_id,
                   MOV.SHIP_TO_ORG_ID,
                   MOV.WAREHOUSE_ID,
                   MOV.TYPE,
                   MOV.WAREHOUSE_NAME,
                   DECODE (
                      MOV.INVENTORY_ITEM_ID,
                      24408, (MOV.SHIPPED_QUANTITY
                              * XXAKG_ONT_PKG.GET_BULK_CONVERSION),
                      206570, (MOV.SHIPPED_QUANTITY
                               * XXAKG_ONT_PKG.GET_BULK_CONVERSION) --add safat for OPC BULK
                                                                   ,
                      MOV.SHIPPED_QUANTITY)
                      SHIPPED_QUANTITY,
                   MOV.SHIPPED_QUANTITY SHIPPED_QUANTITY_ORGINAL,
                   MOV.TRANSPORT_MODE,
                   MOV.ACTUAL_SHIPMENT_DATE,
                   MOV.ACTUAL_SHIPMENT_DATE GL_DATE,
                   MOV.HIRE_RATE_AP,
                   MOV.DO_HDR_ID,
                   MOV.DO_NUMBER,
                   MOV.MOV_ORD_HDR_ID,
                   MOV.MOV_ORDER_NO,
                   MOV.FINAL_DESTINATION,
                   'SCI-CUST-EX' DATA_SOURCE
              FROM XXAKG_DIST_COST_MOV_TEMP MOV
             WHERE MOV.PERIOD_NAME = P_PERIOD_NAME
                   AND TRUNC (MOV.ACTUAL_SHIPMENT_DATE) BETWEEN P_DATE_FROM
                                                            AND P_DATE_TO
                   AND MOV.WAREHOUSE_ID = p_warehouse_id
                   AND MOV.TRANSPORT_MODE IN
                          ('Barge Ex factory', 'Ex factory truck')
                   AND MOV.TYPE = 'GHAT'
                   AND MOV.ORG_ID = 85;

         V_UNIT_GHAT_COST         NUMBER;
         V_UNIT_TO_COST           NUMBER;
         V_UNIT_DIST_COST         NUMBER;

         V_TOT_SHIPPED_QUANTITY   NUMBER;
      BEGIN
         --Start All Ghats Cursor
         FOR ghatrec IN ghatcur
         LOOP
            --Start Period Cursor for a Date Range
            FOR periodrec IN periodcur
            LOOP
               -- SELECT SUM(SHIPPED_QUANTITY)
               SELECT SUM (
                         DECODE (
                            INVENTORY_ITEM_ID,
                            24408, (SHIPPED_QUANTITY
                                    * XXAKG_ONT_PKG.GET_BULK_CONVERSION),
                            206570, (SHIPPED_QUANTITY
                                     * XXAKG_ONT_PKG.GET_BULK_CONVERSION) --add safat for OPC BULK
                                                                         ,
                            SHIPPED_QUANTITY))
                 INTO V_TOT_SHIPPED_QUANTITY
                 FROM XXAKG_DIST_COST_MOV_TEMP MOV
                WHERE MOV.WAREHOUSE_ID = ghatrec.warehouse_id
                      AND MOV.PERIOD_NAME = periodrec.PERIOD_NAME;

               --Start Poplulating TO Data of Ghats Fixed and Varialble Cost
               FOR invrec
                  IN invcur (ghatrec.warehouse_id, periodrec.period_name)
               LOOP
                  --Start Poplulating TO Data which are transfered from Factory to Ghat
                  FOR torec
                     IN tocur (ghatrec.warehouse_id, periodrec.period_name)
                  LOOP
                     DBMS_OUTPUT.PUT_LINE (
                           'torec.invoice_amount 1  - '
                        || torec.invoice_amount
                        || '      '
                        || ghatrec.warehouse_id
                        || '      '
                        || periodrec.period_name);

                     --Start Poplulating Mov order Data which are transfered from Ghat to Customer Site
                     FOR rec
                        IN cur (ghatrec.warehouse_id, periodrec.period_name)
                     LOOP
                        BEGIN
                           IF NVL (invrec.amount, 0) = 0
                           THEN
                              V_UNIT_GHAT_COST := 0;
                           ELSE
                              V_UNIT_GHAT_COST :=
                                 NVL (invrec.amount, 0)
                                 / NVL (V_TOT_SHIPPED_QUANTITY, 0);
                           END IF;

                           IF NVL (torec.invoice_amount, 0) = 0
                           THEN
                              V_UNIT_TO_COST := 0;
                           ELSE
                              V_UNIT_TO_COST :=
                                 NVL (torec.invoice_amount, 0)
                                 / NVL (torec.to_qunatity, 0);
                           END IF;

                           V_UNIT_DIST_COST :=
                              XXAKG_GET_UNIT_DIST_COST (REC.MOV_ORDER_NO,
                                                        'DO');

                           INSERT
                             INTO XXAKG_DISTRIBUTION_COST (
                                     ORG_ID,
                                     CUSTOMER_ID,
                                     HEADER_ID,
                                     ORDER_NUMBER,
                                     LINE_ID,
                                     inventory_item_id,
                                     FROM_WAREHOUSE_ID,
                                     TO_WAREHOUSE_ID,
                                     SHIP_TO_ORG_ID,
                                     ORAGANIZATION_NAME,
                                     SHIPPED_QUANTITY,
                                     FACTORY_GHAT,
                                     TRANSPORT_MODE,
                                     ACTUAL_SHIPMENT_DATE,
                                     INVOICE_GL_DATE,
                                     HIRE_RATE,
                                     UNIT_GHAT_COST,
                                     TOTAL_GHAT_AMOUNT,
                                     UNIT_TO_COST,
                                     TOTAL_TO_AMOUNT,
                                     UNIT_DIST_COST,
                                     DIST_AMOUNT,
                                     ACTUAL_UNIT_DIST_COST,
                                     ACTUAL_DIST_AMOUNT,
                                     DO_HEADER_ID,
                                     DO_NUMBER,
                                     MOV_HEADER_ID,
                                     MOV_ORDER_NO,
                                     FINAL_DESTINATION,
                                     DATA_SOURCE,
                                     TOTAL_TO_QUANTITY_RECON,
                                     TOTAL_TO_AMOUNT_RECON,
                                     TOTAL_GHAT_AMOUNT_RECON,
                                     CREATION_DATE,
                                     CREATED_BY,
                                     LAST_UPDATE_DATE,
                                     LAST_UPDATED_BY)
                           VALUES (
                                     REC.ORG_ID,
                                     REC.CUSTOMER_ID,
                                     REC.HEADER_ID,
                                     REC.ORDER_NUMBER,
                                     REC.LINE_ID,
                                     REC.inventory_item_id,
                                     REC.WAREHOUSE_ID,
                                     NULL,
                                     REC.SHIP_TO_ORG_ID,
                                     REC.WAREHOUSE_NAME,
                                     REC.SHIPPED_QUANTITY,
                                     REC.TYPE,
                                     REC.TRANSPORT_MODE,
                                     REC.ACTUAL_SHIPMENT_DATE,
                                     REC.GL_DATE,
                                     REC.HIRE_RATE_AP,
                                     V_UNIT_GHAT_COST,
                                     ROUND (
                                        V_UNIT_GHAT_COST
                                        * REC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     V_UNIT_TO_COST,
                                     ROUND (
                                        V_UNIT_TO_COST
                                        * REC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     V_UNIT_DIST_COST,
                                     (REC.SHIPPED_QUANTITY_ORGINAL
                                      * V_UNIT_DIST_COST),
                                     (  NVL (V_UNIT_GHAT_COST, 0)
                                      + NVL (V_UNIT_TO_COST, 0)
                                      + NVL (V_UNIT_DIST_COST, 0)),
                                     ROUND (
                                        (  NVL (V_UNIT_GHAT_COST, 0)
                                         + NVL (V_UNIT_TO_COST, 0)
                                         + NVL (V_UNIT_DIST_COST, 0))
                                        * REC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     REC.DO_HDR_ID,
                                     REC.DO_NUMBER,
                                     REC.MOV_ORD_HDR_ID,
                                     REC.MOV_ORDER_NO,
                                     REC.FINAL_DESTINATION,
                                     REC.DATA_SOURCE,
                                     NVL (torec.to_qunatity, 0),
                                     NVL (torec.invoice_amount, 0),
                                     NVL (invrec.amount, 0),
                                     SYSDATE,
                                     0,
                                     SYSDATE,
                                     0);
                        EXCEPTION
                           WHEN ZERO_DIVIDE
                           THEN
                              NULL;
                              DBMS_OUTPUT.PUT_LINE (
                                 'periodrec.period_name - '
                                 || periodrec.period_name);
                              DBMS_OUTPUT.PUT_LINE (
                                 'ghatrec.warehouse_id - '
                                 || ghatrec.warehouse_id);
                              DBMS_OUTPUT.PUT_LINE (
                                 'invrec.amount - ' || NVL (invrec.amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'V_TOT_SHIPPED_QUANTITY - '
                                 || NVL (V_TOT_SHIPPED_QUANTITY, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.invoice_amount - '
                                 || NVL (torec.invoice_amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.to_qunatity - '
                                 || NVL (torec.to_qunatity, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'REC.MOV_ORDER_NO - ' || REC.MOV_ORDER_NO);
                              DBMS_OUTPUT.PUT_LINE (
                                 'REC.DO_NUMBER - ' || REC.DO_NUMBER);
                        END;
                     END LOOP; --End Poplulating Mov order Data which are transfered from Ghat to Customer Site

                     DBMS_OUTPUT.PUT_LINE (
                        'V_TOT_SHIPPED_QUANTITY - ' || V_TOT_SHIPPED_QUANTITY);
                     DBMS_OUTPUT.PUT_LINE (
                        'invrec.amount - ' || invrec.amount);

                     -- TO and Ghat Cost available but not transfer any shipment to customer site
                     IF NVL (V_TOT_SHIPPED_QUANTITY, 0) = 0
                     THEN
                        BEGIN
                           IF NVL (invrec.amount, 0) = 0
                           THEN
                              V_UNIT_GHAT_COST := 0;
                           ELSE
                              V_UNIT_GHAT_COST :=
                                 NVL (invrec.amount, 0)
                                 / NVL (V_TOT_SHIPPED_QUANTITY, 1);
                           END IF;

                           DBMS_OUTPUT.PUT_LINE (
                              'V_UNIT_GHAT_COST - ' || V_UNIT_GHAT_COST);

                           DBMS_OUTPUT.PUT_LINE (
                              'torec.invoice_amount - '
                              || torec.invoice_amount);

                           IF NVL (torec.invoice_amount, 0) = 0
                           THEN
                              V_UNIT_TO_COST := 0;
                           ELSE
                              V_UNIT_TO_COST :=
                                 NVL (torec.invoice_amount, 0)
                                 / NVL (torec.to_qunatity, 0);
                           END IF;

                           DBMS_OUTPUT.PUT_LINE (
                              'V_UNIT_TO_COST - ' || V_UNIT_TO_COST);

                           INSERT
                             INTO XXAKG_DISTRIBUTION_COST (
                                     ORG_ID,
                                     CUSTOMER_ID,
                                     HEADER_ID,
                                     ORDER_NUMBER,
                                     LINE_ID,
                                     inventory_item_id,
                                     FROM_WAREHOUSE_ID,
                                     TO_WAREHOUSE_ID,
                                     SHIP_TO_ORG_ID,
                                     ORAGANIZATION_NAME,
                                     SHIPPED_QUANTITY,
                                     FACTORY_GHAT,
                                     TRANSPORT_MODE,
                                     ACTUAL_SHIPMENT_DATE,
                                     INVOICE_GL_DATE,
                                     HIRE_RATE,
                                     UNIT_GHAT_COST,
                                     TOTAL_GHAT_AMOUNT,
                                     UNIT_TO_COST,
                                     TOTAL_TO_AMOUNT,
                                     UNIT_DIST_COST,
                                     DIST_AMOUNT,
                                     ACTUAL_UNIT_DIST_COST,
                                     ACTUAL_DIST_AMOUNT,
                                     DO_HEADER_ID,
                                     DO_NUMBER,
                                     MOV_HEADER_ID,
                                     MOV_ORDER_NO,
                                     FINAL_DESTINATION,
                                     DATA_SOURCE,
                                     TOTAL_TO_QUANTITY_RECON,
                                     TOTAL_TO_AMOUNT_RECON,
                                     TOTAL_GHAT_AMOUNT_RECON,
                                     CREATION_DATE,
                                     CREATED_BY,
                                     LAST_UPDATE_DATE,
                                     LAST_UPDATED_BY)
                           VALUES (
                                     85,
                                     137156,
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL,
                                     ghatrec.warehouse_id,
                                     NULL,
                                     45517,
                                     ghatrec.WAREHOUSE_NAME,
                                     0,
                                     'GHAT',
                                     'Ex factory truck',
                                     LAST_DAY (
                                        TO_DATE (periodrec.PERIOD_NAME,
                                                 'MON-YY')),
                                     LAST_DAY (
                                        TO_DATE (periodrec.PERIOD_NAME,
                                                 'MON-YY')),
                                     NULL,
                                     V_UNIT_GHAT_COST,
                                     ROUND (V_UNIT_GHAT_COST * 1, 2),
                                     V_UNIT_TO_COST,
                                     ROUND (V_UNIT_TO_COST * 1, 2),
                                     0,
                                     0,
                                     (NVL (V_UNIT_GHAT_COST, 0)
                                      + NVL (V_UNIT_TO_COST, 0)),
                                     ROUND (
                                        (NVL (V_UNIT_GHAT_COST, 0)
                                         + NVL (V_UNIT_TO_COST, 0))
                                        * 1,
                                        2),
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL,
                                     NULL,
                                     'GHAT-CUST-EX',
                                     NVL (torec.to_qunatity, 0),
                                     NVL (torec.invoice_amount, 0),
                                     NVL (invrec.amount, 0),
                                     SYSDATE,
                                     0,
                                     SYSDATE,
                                     0);
                        EXCEPTION
                           WHEN ZERO_DIVIDE
                           THEN
                              NULL;
                              DBMS_OUTPUT.PUT_LINE (
                                 'periodrec.period_name - '
                                 || periodrec.period_name);
                              DBMS_OUTPUT.PUT_LINE (
                                 'ghatrec.warehouse_id - '
                                 || ghatrec.warehouse_id);
                              DBMS_OUTPUT.PUT_LINE (
                                 'invrec.amount - ' || NVL (invrec.amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'V_TOT_SHIPPED_QUANTITY - '
                                 || NVL (V_TOT_SHIPPED_QUANTITY, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.invoice_amount - '
                                 || NVL (torec.invoice_amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.to_qunatity - '
                                 || NVL (torec.to_qunatity, 0));
                        END;
                     END IF;

                     --Start Poplulating Mov order Data which are transfered from Ghat to Customer Site by customer own Cost ('Barge Ex factory', 'Ex factory truck')
                     FOR exrec
                        IN excur (ghatrec.warehouse_id,
                                  periodrec.period_name)
                     LOOP
                        BEGIN
                           IF NVL (invrec.amount, 0) = 0
                           THEN
                              V_UNIT_GHAT_COST := 0;
                           ELSE
                              V_UNIT_GHAT_COST :=
                                 NVL (invrec.amount, 0)
                                 / NVL (V_TOT_SHIPPED_QUANTITY, 0);
                           END IF;

                           IF NVL (torec.invoice_amount, 0) = 0
                           THEN
                              V_UNIT_TO_COST := 0;
                           ELSE
                              V_UNIT_TO_COST :=
                                 NVL (torec.invoice_amount, 0)
                                 / NVL (torec.to_qunatity, 0);
                           END IF;

                           V_UNIT_DIST_COST := 0;

                           INSERT
                             INTO XXAKG_DISTRIBUTION_COST (
                                     ORG_ID,
                                     CUSTOMER_ID,
                                     HEADER_ID,
                                     ORDER_NUMBER,
                                     LINE_ID,
                                     inventory_item_id,
                                     FROM_WAREHOUSE_ID,
                                     TO_WAREHOUSE_ID,
                                     SHIP_TO_ORG_ID,
                                     ORAGANIZATION_NAME,
                                     SHIPPED_QUANTITY,
                                     FACTORY_GHAT,
                                     TRANSPORT_MODE,
                                     ACTUAL_SHIPMENT_DATE,
                                     INVOICE_GL_DATE,
                                     HIRE_RATE,
                                     UNIT_GHAT_COST,
                                     TOTAL_GHAT_AMOUNT,
                                     UNIT_TO_COST,
                                     TOTAL_TO_AMOUNT,
                                     UNIT_DIST_COST,
                                     DIST_AMOUNT,
                                     ACTUAL_UNIT_DIST_COST,
                                     ACTUAL_DIST_AMOUNT,
                                     DO_HEADER_ID,
                                     DO_NUMBER,
                                     MOV_HEADER_ID,
                                     MOV_ORDER_NO,
                                     FINAL_DESTINATION,
                                     DATA_SOURCE,
                                     TOTAL_TO_QUANTITY_RECON,
                                     TOTAL_TO_AMOUNT_RECON,
                                     TOTAL_GHAT_AMOUNT_RECON,
                                     CREATION_DATE,
                                     CREATED_BY,
                                     LAST_UPDATE_DATE,
                                     LAST_UPDATED_BY)
                           VALUES (
                                     EXREC.ORG_ID,
                                     EXREC.CUSTOMER_ID,
                                     EXREC.HEADER_ID,
                                     EXREC.ORDER_NUMBER,
                                     EXREC.LINE_ID,
                                     EXREC.inventory_item_id,
                                     EXREC.WAREHOUSE_ID,
                                     NULL,
                                     EXREC.SHIP_TO_ORG_ID,
                                     EXREC.WAREHOUSE_NAME,
                                     EXREC.SHIPPED_QUANTITY,
                                     EXREC.TYPE,
                                     EXREC.TRANSPORT_MODE,
                                     EXREC.ACTUAL_SHIPMENT_DATE,
                                     EXREC.GL_DATE,
                                     EXREC.HIRE_RATE_AP,
                                     V_UNIT_GHAT_COST,
                                     ROUND (
                                        V_UNIT_GHAT_COST
                                        * EXREC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     V_UNIT_TO_COST,
                                     ROUND (
                                        V_UNIT_TO_COST
                                        * EXREC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     V_UNIT_DIST_COST,
                                     (EXREC.SHIPPED_QUANTITY_ORGINAL
                                      * V_UNIT_DIST_COST),
                                     (  NVL (V_UNIT_GHAT_COST, 0)
                                      + NVL (V_UNIT_TO_COST, 0)
                                      + NVL (V_UNIT_DIST_COST, 0)),
                                     ROUND (
                                        (  NVL (V_UNIT_GHAT_COST, 0)
                                         + NVL (V_UNIT_TO_COST, 0)
                                         + NVL (V_UNIT_DIST_COST, 0))
                                        * EXREC.SHIPPED_QUANTITY_ORGINAL,
                                        2),
                                     EXREC.DO_HDR_ID,
                                     EXREC.DO_NUMBER,
                                     EXREC.MOV_ORD_HDR_ID,
                                     EXREC.MOV_ORDER_NO,
                                     EXREC.FINAL_DESTINATION,
                                     EXREC.DATA_SOURCE,
                                     NVL (torec.to_qunatity, 0),
                                     NVL (torec.invoice_amount, 0),
                                     NVL (invrec.amount, 0),
                                     SYSDATE,
                                     0,
                                     SYSDATE,
                                     0);
                        EXCEPTION
                           WHEN ZERO_DIVIDE
                           THEN
                              NULL;
                              DBMS_OUTPUT.PUT_LINE (
                                 'periodrec.period_name - '
                                 || periodrec.period_name);
                              DBMS_OUTPUT.PUT_LINE (
                                 'ghatrec.warehouse_id - '
                                 || ghatrec.warehouse_id);
                              DBMS_OUTPUT.PUT_LINE (
                                 'invrec.amount - ' || NVL (invrec.amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'V_TOT_SHIPPED_QUANTITY - '
                                 || NVL (V_TOT_SHIPPED_QUANTITY, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.invoice_amount - '
                                 || NVL (torec.invoice_amount, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'torec.to_qunatity - '
                                 || NVL (torec.to_qunatity, 0));
                              DBMS_OUTPUT.PUT_LINE (
                                 'EXREC.MOV_ORDER_NO - '
                                 || EXREC.MOV_ORDER_NO);
                              DBMS_OUTPUT.PUT_LINE (
                                 'EXREC.DO_NUMBER - ' || EXREC.DO_NUMBER);
                        END;
                     END LOOP; --End Poplulating Mov order Data which are transfered from Ghat to Customer Site by customer own Cost ('Barge Ex factory', 'Ex factory truck')
                  END LOOP; --End Poplulating TO Data which are transfered from Factory to Ghat
               END LOOP; --End Poplulating TO Data of Ghats Fixed and Varialble Cost
            END LOOP;                     --End Period Cursor for a Date Range
         END LOOP;                                      --End All Ghats Cursor
      END;
   END IF; --End Population of Mov Data which are transfered from Ghat to Customer Site

   COMMIT;
END;
/
