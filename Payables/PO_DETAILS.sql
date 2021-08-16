SELECT DISTINCT
         A.ORG_ID "ORG ID",
         E.VENDOR_NAME "VENDOR NAME",
         UPPER (E.VENDOR_TYPE_LOOKUP_CODE) "VENDOR TYPE",
         F.VENDOR_SITE_CODE "VENDOR SITE",
         F.ADDRESS_LINE1 "ADDRESS",
         F.CITY "CITY",
         F.COUNTRY "COUNTRY",
         TO_CHAR (TRUNC (D.CREATION_DATE)) "PO DATE",
         D.SEGMENT1 "PO NUMBER",
         D.TYPE_LOOKUP_CODE "PO TYPE",
         C.QUANTITY_ORDERED "QTY ORDERED",
         C.QUANTITY_CANCELLED "QTY CANCALLED",
         G.ITEM_DESCRIPTION "ITEM DESCRIPTION",
         G.UNIT_PRICE "UNIT PRICE",
         (NVL (C.QUANTITY_ORDERED, 0) - NVL (C.QUANTITY_CANCELLED, 0))
         * NVL (G.UNIT_PRICE, 0)
            "PO Line Amount",
         (SELECT   DECODE (PH.APPROVED_FLAG, 'Y', 'Approved')
            FROM   PO.PO_HEADERS_ALL PH
           WHERE   PH.PO_HEADER_ID = D.PO_HEADER_ID)
            "PO STATUS",
         A.INVOICE_TYPE_LOOKUP_CODE "INVOICE TYPE",
         A.INVOICE_AMOUNT "INVOICE AMOUNT",
         TO_CHAR (TRUNC (A.INVOICE_DATE)) "INVOICE DATE",
         A.INVOICE_NUM "INVOICE NUMBER",
         (SELECT   DECODE (X.MATCH_STATUS_FLAG, 'A', 'Approved')
            FROM   AP.AP_INVOICE_DISTRIBUTIONS_ALL X
           WHERE   X.INVOICE_DISTRIBUTION_ID = B.INVOICE_DISTRIBUTION_ID)
            "Invoice Approved?",
         A.AMOUNT_PAID,
         H.AMOUNT,
         I.CHECK_NUMBER "CHEQUE NUMBER",
         TO_CHAR (TRUNC (I.CHECK_DATE)) "PAYMENT DATE"
  FROM   APPS.AP_INVOICES_ALL A,
         APPS.AP_INVOICE_DISTRIBUTIONS_ALL B,
         APPS.PO_DISTRIBUTIONS_ALL C,
         APPS.PO_HEADERS_ALL D,
         APPS.PO_VENDORS E,
         APPS.PO_VENDOR_SITES_ALL F,
         APPS.PO_LINES_ALL G,
         APPS.AP_INVOICE_PAYMENTS_ALL H,
         APPS.AP_CHECKS_ALL I
 WHERE       A.INVOICE_ID = B.INVOICE_ID
         AND B.PO_DISTRIBUTION_ID = C.PO_DISTRIBUTION_ID(+)
         AND C.PO_HEADER_ID = D.PO_HEADER_ID(+)
         AND E.VENDOR_ID(+) = D.VENDOR_ID
         AND F.VENDOR_SITE_ID(+) = D.VENDOR_SITE_ID
         AND D.PO_HEADER_ID = G.PO_HEADER_ID
         AND C.PO_LINE_ID = G.PO_LINE_ID
         AND A.INVOICE_ID = H.INVOICE_ID
         AND H.CHECK_ID = I.CHECK_ID
         AND F.VENDOR_SITE_ID = I.VENDOR_SITE_ID
         AND C.PO_HEADER_ID IS NOT NULL
         AND A.PAYMENT_STATUS_FLAG = 'Y'
         AND D.TYPE_LOOKUP_CODE != 'BLANKET';