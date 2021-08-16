 SELECT 
 aSSa.*,
PHA.ORG_ID,
--APS.SEGMENT1 vendor_NUMBER,
--aps.VENDOR_NAME,
----cust_acct.ACCOUNT_NUMBER CUTOMER_NUMBER,
----party.party_name CUSTOMER_NAME,
PHA.SEGMENT1 "PO NUMBER"
--aia.invoice_num,
--aia.INVOICE_AMOUNT,
--aia.invoice_date,
--aia.invoice_type_lookup_code,
--AIA.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
--TO_CHAR(aia.GL_DATE) GL_DATE,
--aia.description,
----aia.cancelled_date,
--gcc.segment2 "Cost Centre" ,
--gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 "Account",
--gcc.segment3 "Natural Account",
--aila.DESCRIPTION Line_description,
--aipa.accounting_date,
--aipa.amount Payment_amount,
--aipa.period_name,
--aipa.bank_account_num, 
--apsa.GROSS_AMOUNT, 
--apsa.PAYMENT_STATUS_FLAG, 
--apsa.HOLD_FLAG, 
--apsa.PAYMENT_METHOD_CODE,
--aca.AMOUNT CHECK_AMOUNT,  
--aca.BANK_ACCOUNT_NAME, 
--aca.CHECK_DATE
--,assa.ADDRESS_LINE1 ADDRESS
--,fndu.user_name user_id
--,PDA.*
 FROM 
-- apps.ap_invoices_all aia,
--        apps.ap_invoice_lines_all aila,
       apps.ap_suppliers aps,
       apps.ap_supplier_sites_all assa,
--       ,apps.ap_payment_schedules_all apsa,
--       apps.ap_invoice_payments_all aipa,
--       ,apps.ap_checks_all aca
--       APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
       apps.gl_code_combinations gcc
--       ,apps.fnd_user fndu
       ,APPS.PO_DISTRIBUTIONS_ALL PDA
         ,APPS.PO_HEADERS_ALL PHA
         ,APPS.PO_VENDORS PV
         ,APPS.PO_VENDOR_SITES_ALL PVSA
         ,APPS.PO_LINES_ALL PLA
         ,APPS.PO_LINE_LOCATIONS_ALL PLLA
WHERE 1=1
--        AND aia.invoice_id=aila.invoice_id
--        and aia.vendor_id = aps.vendor_id
--       AND aia.vendor_site_id = assa.vendor_site_id
       AND aps.vendor_id = assa.vendor_id
--        AND PHA.PO_HEADER_ID = aila.PO_HEADER_ID
--         AND aila.PO_LINE_ID = PLA.PO_LINE_ID
--       AND aia.invoice_id = apsa.invoice_id
--       AND aipa.invoice_id = aia.invoice_id
--       AND aca.CHECK_ID = aipa.CHECK_ID
--       and AIA.INVOICE_ID=AIDA.INVOICE_ID
--       and aipa.ACCTS_PAY_CODE_COMBINATION_ID=gcc.code_combination_id
--       and fndu.user_id=aia.LAST_UPDATED_BY
--AND PHA.SHIP_TO_LOCATION_ID=aiLa.SHIP_TO_LOCATION_ID
AND PVSA.VENDOR_SITE_ID= assa.VENDOR_SITE_ID
        AND PHA.vendor_id=APS.vendor_id 
        and PDA.code_combination_id=gcc.code_combination_id
       AND PDA.PO_HEADER_ID = PHA.PO_HEADER_ID
         AND PV.VENDOR_ID = PHA.VENDOR_ID
         AND PV.VENDOR_ID=PVSA.VENDOR_ID
         AND PVSA.VENDOR_SITE_ID = PHA.VENDOR_SITE_ID
         AND PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
         AND PDA.PO_LINE_ID = PLA.PO_LINE_ID
         AND PHA.PO_HEADER_ID=PLLA.PO_HEADER_ID
        AND PLA.PO_LINE_ID=PLLA.PO_LINE_ID
--         AND AIDA.PO_DISTRIBUTION_ID=PDA.PO_DISTRIBUTION_ID
         AND PHA.org_id = 85
         AND PHA.SEGMENT1='L/SCOU/027400'
--        AND PDA.PO_HEADER_ID IS NOT NULL
--       AND AIA.INVOICE_NUM='MO/SCOU/966557'
--       and aca.STATUS_LOOKUP_CODE <> 'VOIDED'
--        AND PHA.TYPE_LOOKUP_CODE != 'BLANKET'
--         AND AIA.PAYMENT_STATUS_FLAG = 'Y'


------------------------------------------------------------------------------------------------------------------------------

-------------------------------FOREIGN_SUPPLIER
SELECT
A.ORG_ID "ORG ID",
E.VENDOR_NAME "VENDOR NAME",
UPPER(E.VENDOR_TYPE_LOOKUP_CODE) "VENDOR TYPE",
F.VENDOR_SITE_CODE "VENDOR SITE",
F.ADDRESS_LINE1 "ADDRESS",
F.CITY "CITY",
F.COUNTRY "COUNTRY",
TO_CHAR(TRUNC(D.CREATION_DATE)) "PO DATE",
D.SEGMENT1 "PO NUMBER",
D.TYPE_LOOKUP_CODE "PO TYPE",
C.QUANTITY_ORDERED "QTY ORDERED",
C.QUANTITY_CANCELLED "QTY CANCALLED",
G.ITEM_DESCRIPTION "ITEM DESCRIPTION",
G.UNIT_PRICE "UNIT PRICE",
(NVL(C.QUANTITY_ORDERED,0)-NVL(C.QUANTITY_CANCELLED,0))*NVL(G.UNIT_PRICE,0) "PO Line Amount",
(SELECT
DECODE(PH.APPROVED_FLAG, 'Y', 'Approved')
FROM PO.PO_HEADERS_ALL PH
WHERE PH.PO_HEADER_ID = D.PO_HEADER_ID) "PO STATUS",
A.INVOICE_TYPE_LOOKUP_CODE "INVOICE TYPE",
A.INVOICE_AMOUNT "INVOICE AMOUNT",
TO_CHAR(TRUNC(A.INVOICE_DATE)) "INVOICE DATE",
A.INVOICE_NUM "INVOICE NUMBER",
(SELECT
DECODE(X.MATCH_STATUS_FLAG, 'A', 'Approved')
FROM AP.AP_INVOICE_DISTRIBUTIONS_ALL X
WHERE X.INVOICE_DISTRIBUTION_ID = B.INVOICE_DISTRIBUTION_ID)"Invoice Approved?",
A.AMOUNT_PAID,
H.AMOUNT,
I.CHECK_NUMBER "CHEQUE NUMBER",
TO_CHAR(TRUNC(I.CHECK_DATE)) "PAYMENT DATE"
FROM APPS.AP_INVOICES_ALL A,
APPS.AP_INVOICE_DISTRIBUTIONS_ALL B,
APPS.PO_DISTRIBUTIONS_ALL C,
APPS.PO_HEADERS_ALL D,
APPS.PO_VENDORS E,
APPS.PO_VENDOR_SITES_ALL F,
APPS.PO_LINES_ALL G,
APPS.AP_INVOICE_PAYMENTS_ALL H,
APPS.AP_CHECKS_ALL I
WHERE A.INVOICE_ID = B.INVOICE_ID
AND B.PO_DISTRIBUTION_ID = C. PO_DISTRIBUTION_ID (+)
AND C.PO_HEADER_ID = D.PO_HEADER_ID (+)
AND E.VENDOR_ID (+) = D.VENDOR_ID
AND F.VENDOR_SITE_ID (+) = D.VENDOR_SITE_ID
AND D.PO_HEADER_ID = G.PO_HEADER_ID
AND C.PO_LINE_ID = G.PO_LINE_ID
AND A.INVOICE_ID = H.INVOICE_ID
AND H.CHECK_ID = I.CHECK_ID
AND F.VENDOR_SITE_ID = I.VENDOR_SITE_ID
AND C.PO_HEADER_ID IS NOT NULL
AND A.PAYMENT_STATUS_FLAG = 'Y'
AND D.TYPE_LOOKUP_CODE != 'BLANKET';