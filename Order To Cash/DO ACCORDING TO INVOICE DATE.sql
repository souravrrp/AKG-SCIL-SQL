SELECT
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DOH.DO_NUMBER,
MOH.WAREHOUSE_ORG_CODE,
AIA.INVOICE_NUM,
AIA.CREATION_DATE,
AIA.DOC_SEQUENCE_VALUE
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_MOV_ORD_DTL MODT,
APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.AP_INVOICES_ALL AIA
WHERE 1=1
AND DOH.DO_NUMBER=MODT.DO_NUMBER
AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
AND MOH.MOV_ORDER_NO=AIA.INVOICE_NUM
AND DOH.DO_HDR_ID=MODT.DO_HDR_ID
AND MOH.WAREHOUSE_ORG_CODE='SCI'
AND AIA.CREATION_DATE BETWEEN '15-OCT-2017' and '16-OCT-2017'
--AND DOH.CUSTOMER_NUMBER IN ('20107','20770','184363')




SELECT
DOD.CUSTOMER_NUMBER,
DOD.CUSTOMER_NAME,
DOD.DO_NUMBER,
DOD.WAREHOUSE_ORG_CODE,
INVOICE.INVOICE_NUM,
TO_CHAR (INVOICE.CREATION_DATE, 'DD-MON-YYYY') INVOICE_DATE,
INVOICE.DOC_SEQUENCE_VALUE
FROM
(SELECT
DOH.DO_HDR_ID,
DOH.CUSTOMER_NUMBER,
DOH.CUSTOMER_NAME,
DODL.DO_NUMBER,
DODL.WAREHOUSE_ORG_CODE
FROM
APPS.XXAKG_DEL_ORD_HDR DOH,
APPS.XXAKG_DEL_ORD_DO_LINES DODL
WHERE 1=1
AND DOH.DO_HDR_ID=DODL.DO_HDR_ID
AND DODL.WAREHOUSE_ORG_CODE='SCI') DOD,
(SELECT
MODT.DO_HDR_ID,
AIA.INVOICE_NUM,
AIA.CREATION_DATE,
MODT.DO_NUMBER,
AIA.DOC_SEQUENCE_VALUE
FROM
APPS.AP_INVOICES_ALL AIA,
APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MOH.MOV_ORDER_NO=AIA.INVOICE_NUM
AND MODT.MOV_ORD_HDR_ID = MOH.MOV_ORD_HDR_ID
AND AIA.CREATION_DATE BETWEEN '15-OCT-2017' and '16-OCT-2017') INVOICE
WHERE 1=1
AND INVOICE.DO_NUMBER=DOD.DO_NUMBER
AND INVOICE.DO_HDR_ID=DOD.DO_HDR_ID
--AND DOD.CUSTOMER_NUMBER IN ('20107','20770','184363')
--AND INVOICE.INVOICE_NUM IS NOT NULL



