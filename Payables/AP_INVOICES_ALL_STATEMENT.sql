PROCEDURE CREATE_TRANSPORTER_AP_INVOICE (
      ERRBUF           OUT NOCOPY VARCHAR2,
      RETCODE          OUT NOCOPY NUMBER,
      P_DATE_FROM                 VARCHAR2,
      P_DATE_TO                   VARCHAR2)
   AS
      V_DATE_FROM          DATE := TO_DATE (P_DATE_FROM, 'RRRR/MM/DD  HH24:MI:SS');
      V_DATE_TO            DATE := TO_DATE (P_DATE_TO, 'RRRR/MM/DD  HH24:MI:SS');

      CURSOR CUR
      IS
           SELECT INVOICE_ID,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        VENDOR_ID
                  END
                     VENDOR_ID,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        VENDOR_SITE_ID
                  END
                     VENDOR_SITE_ID,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        INVOICE_NUMBER
                  END
                     INVOICE_NUMBER,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        MIN (TRUNC (INVOICE_DATE))
                           OVER (PARTITION BY INVOICE_ID, INVOICE_NUMBER)
                  END
                     INVOICE_DATE,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        HEADER_DESCRIPTION
                  END
                     HEADER_DESCRIPTION,
                  CASE
                     WHEN LAG (INVOICE_ID)
                             OVER (ORDER BY INVOICE_ID, INVOICE_NUMBER) =
                             INVOICE_ID
                     THEN
                        NULL
                     ELSE
                        SUM (INVOICE_AMOUNT)
                           OVER (PARTITION BY INVOICE_ID, INVOICE_NUMBER)
                  END
                     INVOICE_AMOUNT,
                  INVOICE_LINE_ID,
                  ORDERED_ITEM,
                  ACCOUNTING_DATE,
                  DISTRIBUTION_AMOUNT,
                  DIST_CODE_CONCATENATED,
                  DISTRIBUTION_DESCRIPTION,
                  DISTRIBUTION_ATTRIBUTE14,
                  DISTRIBUTION_ATTRIBUTE15
             FROM (SELECT MVH.MOV_ORD_HDR_ID INVOICE_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (CASE
                                    WHEN MVH.TRANSPORT_MODE IN
                                            ('Company Truck',
                                             'Company Bulk Carrier',
                                             'Company Trailer',
                                             'Company Barge')
                                    THEN
                                       10008
                                    ELSE
                                       MVH.TRANSPORTER_VENDOR_ID
                                 END)
                          END
                             VENDOR_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (CASE
                                    WHEN MVH.TRANSPORT_MODE IN
                                            ('Company Truck',
                                             'Company Bulk Carrier',
                                             'Company Trailer',
                                             'Company Barge')
                                    THEN
                                       13069
                                    ELSE
                                       MVH.TRANSPORTER_VENDOR_SITE_ID
                                 END)
                          END
                             VENDOR_SITE_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                MVH.MOV_ORDER_NO
                          END
                             INVOICE_NUMBER,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                MIN (TRUNC (SOL.ACTUAL_SHIPMENT_DATE))
                                   OVER (PARTITION BY MVH.MOV_ORD_HDR_ID)
                          END
                             INVOICE_DATE,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (   MVH.TRANSPORT_MODE
                                 || ' Transport Hire Charge for: '
                                 || MVH.MOV_ORDER_NO)
                          END
                             HEADER_DESCRIPTION,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                SUM (
                                   ROUND (SOL.SHIPPED_QUANTITY * HIRE_RATE_AP,
                                          2))
                                OVER (PARTITION BY MVH.MOV_ORD_HDR_ID)
                          END
                             INVOICE_AMOUNT,
                          SOL.LINE_ID INVOICE_LINE_ID,
                          SOL.ORDERED_ITEM,
                          TRUNC (SOL.ACTUAL_SHIPMENT_DATE) ACCOUNTING_DATE,
                          ROUND ( (SOL.SHIPPED_QUANTITY * HIRE_RATE_AP), 2)
                             DISTRIBUTION_AMOUNT,
                          (CASE
                              WHEN TRUNC (SOL.ACTUAL_SHIPMENT_DATE) >=
                                      '01-JAN-2012'
                              THEN
                                 (CASE
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Truck',
                                              'Company Bulk Carrier',
                                              'Company Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.GHAT'
                                               || TO_NUMBER (
                                                     SUBSTR (
                                                        MVH.WAREHOUSE_ORG_CODE,
                                                        2))
                                               || '.4031902.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DIST.4031901.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Barge')
                                     THEN
                                        '2110.'
                                        || DECODE (
                                              MVH.WAREHOUSE_ORG_CODE,
                                              'SCI', 'DIST',
                                              'GHAT'
                                              || TO_NUMBER (
                                                    SUBSTR (
                                                       MVH.WAREHOUSE_ORG_CODE,
                                                       2)))
                                        || '.4031903.9999.00'
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Truck', 'Rental Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.GHAT'
                                               || TO_NUMBER (
                                                     SUBSTR (
                                                        MVH.WAREHOUSE_ORG_CODE,
                                                        2))
                                               || '.4031805.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DIST.4031804.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Barge')
                                     THEN
                                        '2110.'
                                        || DECODE (
                                              MVH.WAREHOUSE_ORG_CODE,
                                              'SCI', 'DIST',
                                              'GHAT'
                                              || TO_NUMBER (
                                                    SUBSTR (
                                                       MVH.WAREHOUSE_ORG_CODE,
                                                       2)))
                                        || '.4031808.9999.00'
                                     ELSE
                                        NULL
                                  END)
                              ELSE
                                 (CASE
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Truck',
                                              'Company Bulk Carrier',
                                              'Company Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.DISHO.4031902.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DISHO.4031901.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Barge')
                                     THEN
                                        '2110.DISHO.4031903.9999.00'
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Truck', 'Rental Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.DISHO.4031805.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DISHO.4031804.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Barge')
                                     THEN
                                        '2110.DISHO.4031808.9999.00'
                                     ELSE
                                        NULL
                                  END)
                           END)
                             DIST_CODE_CONCATENATED,
                          SUBSTR (
                                'Charge for: '
                             || DOH.DO_NUMBER
                             || ' Quantity: '
                             || DOL.LINE_QUANTITY
                             || ', Hire Rate: '
                             || MVH.HIRE_RATE_AP
                             || ' From ORG: '
                             || MVH.WAREHOUSE_ORG_CODE
                             || ', TO: '
                             || MVH.FINAL_DESTINATION
                             || ', Was Send To: '
                             || NVL (DOL.ACTUAL_RETAILER_SHIP_TO,
                                     DOL.SHIP_TO_LOCATION),
                             1,
                             238)
                             DISTRIBUTION_DESCRIPTION,
                          SOL.LINE_ID DISTRIBUTION_ATTRIBUTE14,
                          MVD.DO_HDR_ID DISTRIBUTION_ATTRIBUTE15
                     FROM XXAKG_DEL_ORD_HDR DOH,
                          XXAKG_DEL_ORD_DO_LINES DOL,
                          XXAKG_MOV_ORD_DTL MVD,
                          XXAKG_MOV_ORD_HDR MVH,
                          OE_ORDER_LINES_ALL SOL
                    WHERE     DOH.DO_HDR_ID = DOL.DO_HDR_ID
                          AND DOH.ORG_ID = DOL.ORG_ID
                          AND DOH.DO_HDR_ID = MVD.DO_HDR_ID
                          AND MVH.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
                          AND MVH.ORG_ID = DOH.ORG_ID
                          AND MVD.DO_NUMBER = SOL.SHIPMENT_PRIORITY_CODE
                          AND MVH.ORG_ID = SOL.ORG_ID
                          AND DOL.ORDER_HEADER_ID = SOL.HEADER_ID
                          AND DOL.ORDER_LINE_ID = SOL.LINE_ID
                          AND MOV_ORDER_STATUS = 'CONFIRMED'
                          AND AP_FLAG IS NULL
                          AND MVH.ORG_ID = 85
                          AND MOV_ORDER_TYPE = 'RELATED'
                          AND NVL (MVH.HIRE_RATE_AP, 0) > 0
                          AND MVH.READY_FOR_INVOICE = 'Y'
                          AND TRANSPORT_MODE NOT IN
                                 ('Ex factory truck', 'Barge Ex factory')
                          --AND MVH.MOV_ORDER_NO IN ('MO/SCOU/058476')
                          AND TRUNC (SOL.ACTUAL_SHIPMENT_DATE) IS NOT NULL
                          AND TRUNC (SOL.ACTUAL_SHIPMENT_DATE) BETWEEN V_DATE_FROM
                                                                   AND V_DATE_TO
                          AND SOL.INVENTORY_ITEM_ID NOT IN (24397, 24398) -->> EBAG.PBAG.0001 (24397), EBAG.SBAG.0001 (24398)
                          AND NOT EXISTS
                                     (SELECT 1
                                        FROM AP_INVOICES_ALL API
                                       WHERE MVH.MOV_ORDER_NO = API.INVOICE_NUM
                                             AND MVH.ORG_ID = API.ORG_ID)
                   UNION ALL
                   -- Those Line ID is available in Sales Order Line but not in DO line table
                   SELECT MVH.MOV_ORD_HDR_ID INVOICE_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (CASE
                                    WHEN MVH.TRANSPORT_MODE IN
                                            ('Company Truck',
                                             'Company Bulk Carrier',
                                             'Company Trailer',
                                             'Company Barge')
                                    THEN
                                       10008
                                    ELSE
                                       MVH.TRANSPORTER_VENDOR_ID
                                 END)
                          END
                             VENDOR_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (CASE
                                    WHEN MVH.TRANSPORT_MODE IN
                                            ('Company Truck',
                                             'Company Bulk Carrier',
                                             'Company Trailer',
                                             'Company Barge')
                                    THEN
                                       13069
                                    ELSE
                                       MVH.TRANSPORTER_VENDOR_SITE_ID
                                 END)
                          END
                             VENDOR_SITE_ID,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                MVH.MOV_ORDER_NO
                          END
                             INVOICE_NUMBER,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                MIN (TRUNC (SOL.ACTUAL_SHIPMENT_DATE))
                                   OVER (PARTITION BY MVH.MOV_ORD_HDR_ID)
                          END
                             INVOICE_DATE,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                (   MVH.TRANSPORT_MODE
                                 || ' Transport Hire Charge for: '
                                 || MVH.MOV_ORDER_NO)
                          END
                             HEADER_DESCRIPTION,
                          CASE
                             WHEN LAG (MVH.MOV_ORD_HDR_ID)
                                     OVER (ORDER BY MVH.MOV_ORD_HDR_ID) =
                                     MVH.MOV_ORD_HDR_ID
                             THEN
                                NULL
                             ELSE
                                SUM (
                                   ROUND (SOL.SHIPPED_QUANTITY * HIRE_RATE_AP,
                                          2))
                                OVER (PARTITION BY MVH.MOV_ORD_HDR_ID)
                          END
                             INVOICE_AMOUNT,
                          SOL.LINE_ID INVOICE_LINE_ID,
                          SOL.ORDERED_ITEM,
                          TRUNC (SOL.ACTUAL_SHIPMENT_DATE) ACCOUNTING_DATE,
                          ROUND ( (SOL.SHIPPED_QUANTITY * HIRE_RATE_AP), 2)
                             DISTRIBUTION_AMOUNT,
                          (CASE
                              WHEN TRUNC (SOL.ACTUAL_SHIPMENT_DATE) >=
                                      '01-JAN-2012'
                              THEN
                                 (CASE
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Truck',
                                              'Company Bulk Carrier',
                                              'Company Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.GHAT'
                                               || TO_NUMBER (
                                                     SUBSTR (
                                                        MVH.WAREHOUSE_ORG_CODE,
                                                        2))
                                               || '.4031902.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DIST.4031901.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Barge')
                                     THEN
                                        '2110.'
                                        || DECODE (
                                              MVH.WAREHOUSE_ORG_CODE,
                                              'SCI', 'DIST',
                                              'GHAT'
                                              || TO_NUMBER (
                                                    SUBSTR (
                                                       MVH.WAREHOUSE_ORG_CODE,
                                                       2)))
                                        || '.4031903.9999.00'
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Truck', 'Rental Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.GHAT'
                                               || TO_NUMBER (
                                                     SUBSTR (
                                                        MVH.WAREHOUSE_ORG_CODE,
                                                        2))
                                               || '.4031805.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DIST.4031804.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Barge')
                                     THEN
                                        '2110.'
                                        || DECODE (
                                              MVH.WAREHOUSE_ORG_CODE,
                                              'SCI', 'DIST',
                                              'GHAT'
                                              || TO_NUMBER (
                                                    SUBSTR (
                                                       MVH.WAREHOUSE_ORG_CODE,
                                                       2)))
                                        || '.4031808.9999.00'
                                     ELSE
                                        NULL
                                  END)
                              ELSE
                                 (CASE
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Truck',
                                              'Company Bulk Carrier',
                                              'Company Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.DISHO.4031902.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DISHO.4031901.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Company Barge')
                                     THEN
                                        '2110.DISHO.4031903.9999.00'
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Truck', 'Rental Trailer')
                                     THEN
                                        (CASE
                                            WHEN MVH.WAREHOUSE_ORG_CODE LIKE
                                                    'G%'
                                                 AND MVH.WAREHOUSE_ORG_CODE <>
                                                        'GIO'
                                            THEN
                                               '2110.DISHO.4031805.9999.00'
                                            ----For GHAT WareHouse
                                            ELSE
                                               '2110.DISHO.4031804.9999.00'
                                         ---For FACTORY(Non GHAT) WareHouse
                                         END)
                                     WHEN MVH.TRANSPORT_MODE IN
                                             ('Rental Barge')
                                     THEN
                                        '2110.DISHO.4031808.9999.00'
                                     ELSE
                                        NULL
                                  END)
                           END)
                             DIST_CODE_CONCATENATED,
                          SUBSTR (   'Charge for: '
                                  || DOH.DO_NUMBER
                                  || ' Quantity: '
                                  || SOL.SHIPPED_QUANTITY
                                  || ', Hire Rate: '
                                  || MVH.HIRE_RATE_AP
                                  || ' From ORG: '
                                  || MVH.WAREHOUSE_ORG_CODE
                                  || ', TO: '
                                  || MVH.FINAL_DESTINATION
                                  || ', Was Send To: '
                                  || (SELECT LOCATION
                                        FROM HZ_CUST_SITE_USES_ALL
                                       WHERE SITE_USE_ID = SOL.SHIP_TO_ORG_ID),
                                  1,
                                  238)
                             DISTRIBUTION_DESCRIPTION,
                          SOL.LINE_ID DISTRIBUTION_ATTRIBUTE14,
                          MVD.DO_HDR_ID DISTRIBUTION_ATTRIBUTE15
                     FROM XXAKG_DEL_ORD_HDR DOH,
                          --                          XXAKG_DEL_ORD_DO_LINES DOL,
                          XXAKG_MOV_ORD_DTL MVD,
                          XXAKG_MOV_ORD_HDR MVH,
                          OE_ORDER_LINES_ALL SOL
                    WHERE     1 = 1
                          --                          AND  DOH.DO_HDR_ID = DOL.DO_HDR_ID
                          --                          AND DOH.ORG_ID = DOL.ORG_ID
                          AND DOH.DO_HDR_ID = MVD.DO_HDR_ID
                          AND MVH.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
                          AND MVH.ORG_ID = DOH.ORG_ID
                          AND MVD.DO_NUMBER = SOL.SHIPMENT_PRIORITY_CODE
                          AND MVH.ORG_ID = SOL.ORG_ID
                          --                          AND DOL.ORDER_HEADER_ID = SOL.HEADER_ID
                          --AND DOL.ORDER_LINE_ID = SOL.LINE_ID
                          AND MOV_ORDER_STATUS = 'CONFIRMED'
                          AND AP_FLAG IS NULL
                          AND MVH.ORG_ID = 85
                          AND MOV_ORDER_TYPE = 'RELATED'
                          AND NVL (MVH.HIRE_RATE_AP, 0) > 0
                          AND MVH.READY_FOR_INVOICE = 'Y'
                          AND TRANSPORT_MODE NOT IN
                                 ('Ex factory truck', 'Barge Ex factory')
                          --AND MVH.MOV_ORDER_NO IN ('MO/SCOU/058476')
                          AND TRUNC (SOL.ACTUAL_SHIPMENT_DATE) IS NOT NULL
                          AND TRUNC (SOL.ACTUAL_SHIPMENT_DATE) BETWEEN V_DATE_FROM
                                                                   AND V_DATE_TO
                          AND SOL.INVENTORY_ITEM_ID NOT IN (24397, 24398) -->> EBAG.PBAG.0001 (24397), EBAG.SBAG.0001 (24398)
                          AND NOT EXISTS
                                     (SELECT 1
                                        FROM AP_INVOICES_ALL API
                                       WHERE MVH.MOV_ORDER_NO = API.INVOICE_NUM
                                             AND MVH.ORG_ID = API.ORG_ID)
                          AND NOT EXISTS
                                     (SELECT 1
                                        FROM XXAKG_DEL_ORD_DO_LINES DOL1
                                       WHERE DOL1.ORDER_LINE_ID = SOL.LINE_ID
                                             AND DOL1.ORG_ID = SOL.ORG_ID)
                          AND EXISTS
                                 (SELECT 2
                                    FROM XXAKG.XXAKG_DEL_ORD_DO_LINES DOL2
                                   WHERE DOL2.ORDER_HEADER_ID = SOL.HEADER_ID
                                         AND DOL2.ORDERED_ITEM_ID =
                                                SOL.ORDERED_ITEM_ID
                                         AND DOL2.DO_NUMBER =
                                                SOL.SHIPMENT_PRIORITY_CODE))
         ORDER BY INVOICE_ID;

      V_INVOICE_AMOUNT     NUMBER;
      V_INVOICE_LINE_ID    NUMBER;
      V_LINE_NUMBER        NUMBER;
      R_REQUEST_ID         NUMBER;
      V_REQUEST_STATUS     VARCHAR2 (5);
      V_SHIPPMENT_STATUS   NUMBER;
   BEGIN
      DELETE FROM AP.AP_INVOICE_LINES_INTERFACE
            WHERE INVOICE_ID IN (SELECT INVOICE_ID
                                   FROM AP_INVOICES_INTERFACE
                                  WHERE SOURCE = 'AKG TRIP INVOICE');

      DELETE FROM AP.AP_INVOICES_INTERFACE
            WHERE SOURCE = 'AKG TRIP INVOICE';

      COMMIT;

      FOR REC IN CUR
      LOOP
         BEGIN
            IF REC.INVOICE_NUMBER IS NOT NULL
            THEN
               V_SHIPPMENT_STATUS :=
                  XXAKG_ONT_PKG.GET_FULL_SHIPPMENT_STATUS (REC.INVOICE_ID,
                                                           V_DATE_FROM,
                                                           V_DATE_TO);
            END IF;

            IF V_SHIPPMENT_STATUS = 1
            THEN
               IF REC.INVOICE_NUMBER IS NOT NULL
               THEN
                  INSERT
                    INTO AP_INVOICES_INTERFACE (INVOICE_ID,
                                                INVOICE_NUM,
                                                INVOICE_TYPE_LOOKUP_CODE,
                                                INVOICE_DATE,
                                                INVOICE_AMOUNT,
                                                VENDOR_ID,
                                                VENDOR_SITE_ID,
                                                INVOICE_CURRENCY_CODE,
                                                DESCRIPTION,
                                                TERMS_ID,
                                                PAYMENT_METHOD_LOOKUP_CODE,
                                                SOURCE,
                                                GL_DATE,
                                                ORG_ID,
                                                APPLICATION_ID,
                                                ATTRIBUTE13,
                                                ATTRIBUTE15)
                  VALUES (AP_INVOICES_INTERFACE_S.NEXTVAL,
                          REC.INVOICE_NUMBER,
                          'STANDARD',
                          REC.INVOICE_DATE,
                          REC.INVOICE_AMOUNT,
                          REC.VENDOR_ID,
                          REC.VENDOR_SITE_ID,
                          'BDT',
                          REC.HEADER_DESCRIPTION,
                          10000,
                          'AKG_CHEQUE',
                          'AKG TRIP INVOICE',
                          REC.INVOICE_DATE,
                          85,
                          200,
                          REC.INVOICE_NUMBER,
                          REC.INVOICE_ID);

                  V_LINE_NUMBER := 0;
               END IF;

               V_LINE_NUMBER := NVL (V_LINE_NUMBER, 0) + 1;

               INSERT
                 INTO AP_INVOICE_LINES_INTERFACE (INVOICE_ID,
                                                  INVOICE_LINE_ID,
                                                  LINE_NUMBER,
                                                  LINE_TYPE_LOOKUP_CODE,
                                                  AMOUNT,
                                                  ACCOUNTING_DATE,
                                                  DESCRIPTION,
                                                  DIST_CODE_CONCATENATED,
                                                  ATTRIBUTE14,
                                                  ATTRIBUTE15)
               VALUES (AP_INVOICES_INTERFACE_S.CURRVAL,
                       AP_INVOICE_LINES_INTERFACE_S.NEXTVAL,
                       V_LINE_NUMBER,
                       'ITEM',
                       REC.DISTRIBUTION_AMOUNT,
                       REC.ACCOUNTING_DATE,
                       REC.DISTRIBUTION_DESCRIPTION,
                       REC.DIST_CODE_CONCATENATED,
                       REC.DISTRIBUTION_ATTRIBUTE14,
                       REC.DISTRIBUTION_ATTRIBUTE15);
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.PUT_LINE (SQLERRM);
               DBMS_OUTPUT.PUT_LINE ('INVOICE_ID ' || REC.INVOICE_ID);
               DBMS_OUTPUT.PUT_LINE ('INVOICE_NUMBER ' || REC.INVOICE_NUMBER);
               DBMS_OUTPUT.PUT_LINE (
                  'INVOICE_LINE_ID ' || REC.INVOICE_LINE_ID);
         END;
      END LOOP;

      COMMIT;
      SUBMIT_REQUEST (FND_PROFILE.VALUE ('APPL_ID'),
                      FND_PROFILE.VALUE ('ORG_ID'),
                      FND_PROFILE.VALUE ('USER_ID'),
                      FND_PROFILE.VALUE ('RESP_ID'),
                      'AKG TRIP INVOICE',
                      'APXIIMPT',
                      R_REQUEST_ID);

      IF R_REQUEST_ID > 0
      THEN
         COMMIT;

         WHILE NVL (V_REQUEST_STATUS, 'X') NOT IN ('C', 'E')
         LOOP
            DBMS_LOCK.SLEEP (5);

            SELECT STATUS_CODE
              INTO V_REQUEST_STATUS
              FROM FND_CONC_REQ_SUMMARY_V
             WHERE RESPONSIBILITY_APPLICATION_ID = 200
                   AND REQUEST_ID = R_REQUEST_ID;
         END LOOP;

         -- Update AP_FLAG based Processed Data
         UPDATE XXAKG_MOV_ORD_HDR
            SET AP_FLAG = 'Y'
          WHERE MOV_ORD_HDR_ID IN
                   (SELECT ATTRIBUTE15
                      FROM AP_INVOICES_INTERFACE
                     WHERE STATUS = 'PROCESSED' AND REQUEST_ID = R_REQUEST_ID);

         COMMIT;
      END IF;
   END CREATE_TRANSPORTER_AP_INVOICE;