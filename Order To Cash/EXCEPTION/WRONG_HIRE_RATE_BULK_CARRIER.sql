SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
SUM(AIDA.AMOUNT) AMOUNT,
(SELECT SUM(DECODE (DODL.UOM_CODE, 'MTN', DODL.LINE_QUANTITY*20,
                                        'BAG', DODL.LINE_QUANTITY)) QTY FROM APPS.XXAKG_DEL_ORD_DO_LINES DODL WHERE DODL.DO_HDR_ID=MOH.DO_HDR_ID) TOTAL_QUANTITY,
aia.invoice_num Move_number,
TO_CHAR (MOH.MOV_ORDER_DATE) MOVE_Order_DATE,
MOH.WAREHOUSE_ORG_CODE WAREHOUSE,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO
--,AIDA.*
  FROM apps.ap_invoices_all aia
  ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
  ,apps.gl_code_combinations gcc
       ,APPS.XXAKG_DO_MO_DETAILS MOH
WHERE 1=1
AND AIA.SOURCE IN ('AKG TRIP INVOICE')
AND aia.invoice_num=MOH.MOV_ORDER_NO
and AIDA.ATTRIBUTE15=MOH.DO_HDR_ID
        AND aia.invoice_id=AIDA.invoice_id
        AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
       AND aia.org_id = 85
--       AND aia.invoice_num='MO/SCOU/1029232'
--       AND gcc.segment2='GHAT21'
--       AND TO_CHAR (mOH.mov_order_date, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
--       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='FEB-18'
       AND MOH.VEHICLE_TYPE='Owned By Company'
       AND MOH.TRANSPORT_MODE='Company Bulk Carrier'
       AND EXISTS (SELECT 1 FROM APPS.XXAKG_TRANSPORT_HIRERATE  TH WHERE ORG_ID=85 AND TH.FROM_LOCATION=MOH.WAREHOUSE_ORG_ID AND MOH.FINAL_DESTINATION=TH.TO_LOCATION  AND TH.TRANSPORT_MODE=MOH.TRANSPORT_MODE AND END_DATE_ACTIVE IS NULL  AND TH.TO_LOCATION IN ('Uttara','Ashulia','Keranigonj','Tangail','Feni','Noakhali','Voirob Ghat'))
    group by
    gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
    aia.INVOICE_AMOUNT,
    MOH.DO_HDR_ID,
    MOH.DO_QUANTITY,
    aia.invoice_num,
    TO_CHAR (MOH.MOV_ORDER_DATE),
    MOH.WAREHOUSE_ORG_CODE,
    MOH.FINAL_DESTINATION,
    MOH.TRANSPORT_MODE
    ,MOH.VEHICLE_NO
UNION ALL
SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
aia.INVOICE_AMOUNT AMOUNT,
SUM(DECODE (TDL.UOM_CODE, 'MTN', TDL.QUANTITY*20,
                                        'BAG', TDL.QUANTITY)) TOTAL_QUANTITY,
aia.invoice_num Move_number,
TO_CHAR (TMH.MOV_ORDER_DATE) MOVE_Order_DATE,
TMH.FROM_INV WAREHOUSE,
TMH.FINAL_DESTINATION,
TMH.TRANSPORT_MODE
,TMH.VEHICLE_NO
--,aila.*
  FROM apps.ap_invoices_all aia
  ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
  ,apps.gl_code_combinations gcc
       ,XXAKG.XXAKG_TO_MO_HDR TMH
       ,XXAKG.XXAKG_TO_DO_LINES TDL
       ,APPS.XXAKG_TO_MO_DTL TMD
WHERE 1=1
AND AIA.SOURCE IN ('AKG TRIP INVOICE TO')
AND TMD.TO_HDR_ID=TDL.TO_HDR_ID
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
AND aia.invoice_num=TMH.MOV_ORDER_NO
        AND aia.invoice_id=AIDA.invoice_id
        AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
       AND aia.org_id = 85
--       AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
--       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='FEB-18'
--       AND gcc.segment2='GHAT21'
AND TMH.VEHICLE_TYPE='Owned By Company'
    AND EXISTS (SELECT 1 FROM APPS.XXAKG_TRANSPORT_HIRERATE  TH, APPS.ORG_ORGANIZATION_DEFINITIONS OOD WHERE TH.ORG_ID=85  AND TMH.FINAL_DESTINATION=TH.TO_LOCATION  AND TH.TRANSPORT_MODE=TMH.TRANSPORT_MODE AND TH.END_DATE_ACTIVE IS NULL  AND TH.TO_LOCATION IN ('Uttara','Ashulia','Keranigonj','Tangail','Feni','Noakhali','Voirob Ghat')
                                                                                                                                                                                            AND TH.ORG_ID=OOD.OPERATING_UNIT AND TH.FROM_LOCATION=OOD.ORGANIZATION_ID)
       AND TMH.TRANSPORT_MODE='Company Bulk Carrier'
GROUP BY
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
aia.invoice_num,
TO_CHAR (TMH.MOV_ORDER_DATE),
TMH.FROM_INV,
TMH.FINAL_DESTINATION,
TMH.TRANSPORT_MODE
,TMH.VEHICLE_NO