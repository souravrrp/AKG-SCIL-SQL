SELECT
CCD.ORG_ID,
CCD.CUST_COMMIT_ID,
CCH.CUSTOMER_NUMBER, 
CCH.CUSTOMER_NAME,
CCD.COMMITMENT_AMOUNT,
CCD.COMMITMENT_DATE,
CCD.REMARKS COMMITMENT_REMARKS,
CCD.COLLECTION_AMOUNT,
CCD.RECEIPT_NUMBER,
CCD.RECEIPT_DATE,
CCH.ORDER_NUMBER
--,CCD.*
,CCH.*
FROM
APPS.XXAKG_CUST_COMMITMENT_H CCH,
APPS.XXAKG_CUST_COMMITMENT_D CCD
,APPS.OE_ORDER_LINES_ALL OOL
WHERE 1=1
AND CCH.OE_HEADER_ID=OOL.HEADER_ID(+)
AND CCD.ORG_ID=85
AND CCD.ORG_ID=CCH.ORG_ID
AND CCH.CUST_COMMIT_ID=CCH.CUST_COMMIT_ID
AND CCD.CUSTOMER_ID=CCH.CUSTOMER_ID
--AND CCH.ORDER_NUMBER=:ORDER_NO 



--------------------------------------------------------------------------------
SELECT
CCD.ORG_ID,
CUST_COMMIT_ID,
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (CCD.CUSTOMER_ID) CUSTOMER_NUMBER, 
APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_FROM_ID (CCD.CUSTOMER_ID) CUSTOMER_NAME,
CCD.COMMITMENT_AMOUNT,
CCD.COMMITMENT_DATE,
CCD.REMARKS COMMITMENT_REMARKS,
CCD.COLLECTION_AMOUNT,
CCD.RECEIPT_NUMBER,
CCD.RECEIPT_DATE
,CCD.*
FROM
APPS.XXAKG_CUST_COMMITMENT_D CCD
WHERE 1=1
--AND 


SELECT
CCH.ORG_ID,
CCH.CUST_COMMIT_ID,
CCH.CUSTOMER_NUMBER, 
CCH.CUSTOMER_NAME,
CCH.*
FROM
APPS.XXAKG_CUST_COMMITMENT_H CCH