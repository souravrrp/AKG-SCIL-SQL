SELECT
MOV_ORDER_NO
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND MOH.ORG_ID=85
AND TO_CHAR(MOH.MOV_ORDER_DATE,'RRRR')='2018'
AND MOH.VEHICLE_TYPE='Owned By Company'
AND EXISTS (SELECT 1 FROM APPS.AP_INVOICES_ALL AI,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AI.ORG_ID=82 AND AI.INVOICE_ID=AIDA.INVOICE_ID 
AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO)
UNION ALL
SELECT
MOV_ORDER_NO
FROM
XXAKG.XXAKG_TO_MO_HDR TMH
WHERE 1=1
AND TMH.ORG_ID=85
AND TO_CHAR(TMH.MOV_ORDER_DATE,'RRRR')='2018'
AND TMH.VEHICLE_TYPE='Owned By Company'
AND EXISTS (SELECT 1 FROM APPS.AP_INVOICES_ALL AI,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AI.ORG_ID=82 AND AI.INVOICE_ID=AIDA.INVOICE_ID 
AND AIDA.ATTRIBUTE2=TMH.MOV_ORDER_NO)


SELECT
MOV_ORDER_NO
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND MOH.ORG_ID=85
AND TO_CHAR(MOH.MOV_ORDER_DATE,'RRRR')='2018'
AND MOH.VEHICLE_TYPE='Owned By Company'
AND NOT EXISTS (SELECT 1 FROM APPS.AP_INVOICES_ALL AI,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AI.ORG_ID=82 AND AI.INVOICE_ID=AIDA.INVOICE_ID 
AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO)
UNION ALL
SELECT
MOV_ORDER_NO
FROM
XXAKG.XXAKG_TO_MO_HDR TMH
WHERE 1=1
AND TMH.ORG_ID=85
AND TO_CHAR(TMH.MOV_ORDER_DATE,'RRRR')='2018'
AND TMH.VEHICLE_TYPE='Owned By Company'
AND NOT EXISTS (SELECT 1 FROM APPS.AP_INVOICES_ALL AI,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AI.ORG_ID=82 AND AI.INVOICE_ID=AIDA.INVOICE_ID 
AND AIDA.ATTRIBUTE2=TMH.MOV_ORDER_NO)

SELECT
*
FROM
APPS.FND_FORM_CUSTOM_RULES 
WHERE 1=1
AND FUNCTION_NAME='AP_APXINWKB'
--AND DESCRIPTION='Duplicate Move'  -- CLONE6
AND DESCRIPTION='Checking Duplicate Move Order'--PROD


SELECT
*
FROM
APPS.FND_FORM_CUSTOM_ACTIONS
WHERE 1=1
--AND MESSAGE_TEXT='The Move number is already used!!!'  -- CLONE6
AND MESSAGE_TEXT='The MOVE Number is already used!!!' --PROD

SELECT
*
FROM
APPS.FND_FORM_CUSTOM_RULES CR
,APPS.FND_FORM_CUSTOM_ACTIONS CA
WHERE 1=1
AND CR.ID=CA.RULE_ID
AND FORM_NAME='APXINWKB'
AND FUNCTION_NAME='AP_APXINWKB'
AND DESCRIPTION='Duplicate Move'  -- CLONE6
--AND DESCRIPTION='Checking Duplicate Move Order'

--------------------------------------------------------------------------------
/* Formatted on 6/15/2019 12:31:45 PM (QP5 v5.163.1008.3004) 
CREATE OR REPLACE FUNCTION APPS.XXAKG_CHECK_DUP_MOVE_INVOICE (
   P_MOVE_NUM         VARCHAR2,
   P_RECORD_STATUS    VARCHAR2 DEFAULT 'INSERT')
   RETURN VARCHAR2
AS
   V_COUNT   NUMBER;
BEGIN
   SELECT COUNT (DISTINCT (API.INVOICE_ID))
     --   INVOICE_NUM,AD.*
     INTO V_COUNT
     FROM AP_INVOICES_ALL API, APPS.AP_INVOICE_DISTRIBUTIONS_ALL AD
    WHERE     API.ORG_ID = 82
          AND API.INVOICE_ID = AD.INVOICE_ID
          AND AD.ATTRIBUTE_CATEGORY = 'Trip Extra Charges'
          AND UPPER (AD.ATTRIBUTE2) = UPPER (P_MOVE_NUM)
          AND API.CANCELLED_DATE IS NULL;

   IF P_RECORD_STATUS = 'INSERT' AND V_COUNT > 1  
   THEN
      RETURN 'YES';   --should RETURN �NO� Because voucher is already exists for this trip. Since count > 1
   ELSIF P_RECORD_STATUS = 'CHANGED' AND V_COUNT > 1
   THEN
      RETURN 'YES';
   ELSE
      RETURN 'NO';
   END IF;
END;
/
*/
--------------------------------------------------------------------------------VALUE SET
--xxakg_move_num      --clone6
--AKG_DRIVER_TRIP_NUM --test-dbclone

SELECT
*
from
--apps.xxakg_eligable_move_list--clone6
--apps.XXAKG_TRIP_MOVE_NUMBER--dbclone
APPS.XXAKG_TRIP_MOVE_NUMBER --PROD