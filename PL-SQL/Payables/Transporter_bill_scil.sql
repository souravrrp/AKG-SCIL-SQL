SELECT
    DBM.REGION_NAME,
    MODT.CUSTOMER_NUMBER,
    DBM.CUSTOMER_NAME,
--    ORD.DO_NUMBER,
    MOH.MOV_ORDER_NO,
    SUM(ORD.ORDERED_QUANTITY) QUANTITY
,SUM(ORD.ORDERED_AMT) AMOUNT
--,MOH.TRANSPORTER_NAME
,APS.SEGMENT1 TRANSPORTER_NO
,APS.VENDOR_NAME TRANSPORTER
--,MOH.TRANSPORTER_VENDOR_SITE_ID
,APSA.VENDOR_SITE_CODE TRANSPORTER_SITE
,MOH.VEHICLE_NO
,MOH.VEHICLE_TYPE
,MOH.TRANSPORT_MODE
,MOH.HIRE_RATE_AP PAYMENT
,MOH.DEMURRAGE
FROM
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM,
APPS.XXAKG_MOV_ORD_DTL MODT,
      APPS.XXAKG_MOV_ORD_HDR MOH,
APPS.XXAKG_HEADER_DETAIL_V ORD
,APPS.AP_SUPPLIERS APS
,APPS.AP_SUPPLIER_SITES_ALL APSA
WHERE 1=1
AND APS.VENDOR_ID=APSA.VENDOR_ID
AND MOH.TRANSPORTER_VENDOR_ID=APS.VENDOR_ID
AND MOH.TRANSPORTER_VENDOR_SITE_ID=APSA.VENDOR_SITE_ID
      AND MOH.MOV_ORD_HDR_ID = MODT.MOV_ORD_HDR_ID
      AND MODT.DO_NUMBER = ORD.DO_NUMBER
      AND MOH.ORG_ID = ORD.ORG_ID
      AND DBM.ORG_ID = ORD.ORG_ID
      AND APSA.ORG_ID = ORD.ORG_ID
      AND MODT.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER
--      AND MOH.TRANSPORT_MODE='Rental Truck'
      AND MOH.MOV_ORDER_STATUS='CONFIRMED'
      AND MOH.TRANSPORTER_VENDOR_ID='4196'
--      AND MOH.TRANSPORTER_NAME='M/S Borsha Paribahan Songstha ~ GAZIPUR-CER'
--      AND APS.VENDOR_NAME='M/S Borsha Paribahan Songstha'
--      AND APS.SEGMENT1='13966'
--      AND TO_CHAR(APS.SEGMENT1)=TO_CHAR(:P_TRANSPORTER_NUMBER)
--      AND DBM.CUSTOMER_NUMBER=:P_CUSTOMER_NUMBER
--      AND ORD.DO_NUMBER=:P_DO_NUMBER
--      AND MOH.MOV_ORDER_NO=:P_MOV_ORDER_NO
AND ORD.ORG_ID=85
AND APS.VENDOR_TYPE_LOOKUP_CODE='TRANSPORTER'
--AND ORD.PERIOD='JAN-18'
AND TO_CHAR (MOH.CONFIRMED_DATE, 'MON-RR') = 'JAN-18'
AND ORD.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
--AND ROWNUM<=2
GROUP BY
DBM.REGION_NAME,
    MODT.CUSTOMER_NUMBER,
    DBM.CUSTOMER_NAME,
--    ORD.DO_NUMBER,
    MOH.MOV_ORDER_NO
--    ,MOH.TRANSPORTER_NAME
,MOH.VEHICLE_TYPE
,MOH.TRANSPORT_MODE
,MOH.HIRE_RATE_AP
,MOH.DEMURRAGE
,APS.SEGMENT1
,APS.VENDOR_NAME
--,MOH.TRANSPORTER_VENDOR_SITE_ID
,APSA.VENDOR_SITE_CODE
,MOH.VEHICLE_NO


SELECT DISTINCT
--MOH.TRANSPORTER_VENDOR_ID
--,MOH.TRANSPORTER_NAME
--,MOH.TRANSPORTER_VENDOR_SITE_ID
APS.VENDOR_ID
,APS.SEGMENT1 TRANSPORTER_NO
,APS.VENDOR_NAME TRANSPORTER
,APSA.VENDOR_SITE_CODE TRANSPORTER_SITE
,MOH.MOV_ORDER_NO
,TO_CHAR(MOH.CONFIRMED_DATE) CONFIRMED_DATE
--,APSA.*
FROM
APPS.AP_SUPPLIERS APS,
APPS.AP_SUPPLIER_SITES_ALL APSA
,APPS.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND APS.VENDOR_ID=APSA.VENDOR_ID
AND MOH.TRANSPORTER_VENDOR_ID=APS.VENDOR_ID
AND MOH.TRANSPORTER_VENDOR_SITE_ID=APSA.VENDOR_SITE_ID
AND MOH.READY_FOR_INVOICE='Y'
--AND APS.VENDOR_ID='4847'
AND VENDOR_SITE_ID='836708'
AND APS.SEGMENT1='3062'
--AND TO_CHAR(APS.SEGMENT1)=TO_CHAR(:P_TRANSPORTER_NUMBER)
--AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE AIA.INVOICE_NUM=MOH.MOV_ORDER_NO)
AND EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE AIA.INVOICE_NUM=MOH.MOV_ORDER_NO AND )




SELECT --DISTINCT
--MOH.TRANSPORTER_VENDOR_ID
--,MOH.TRANSPORTER_NAME
--,MOH.TRANSPORTER_VENDOR_SITE_ID
--APS.VENDOR_ID
--,APS.SEGMENT1 TRANSPORTER_NO
--,APS.VENDOR_NAME TRANSPORTER
MOH.MOV_ORDER_NO
,AIA.VENDOR_ID
,MOH.TRANSPORTER_VENDOR_ID
,AIA.VENDOR_SITE_ID
,MOH.TRANSPORTER_VENDOR_SITE_ID
,TO_CHAR(MOH.MOV_ORDER_DATE) MOVE_ORDER_DATE
,TO_CHAR(AIA.INVOICE_DATE) INVOICE_DATE
--,APSA.*
FROM
--APPS.AP_SUPPLIERS APS,
--APPS.AP_SUPPLIER_SITES_ALL APSA
APPS.XXAKG_MOV_ORD_HDR MOH
,APPS.AP_INVOICES_ALL AIA
WHERE 1=1
--AND MOH.ORG_ID=85
AND AIA.INVOICE_NUM=MOH.MOV_ORDER_NO
AND MOH.TRANSPORTER_VENDOR_ID=AIA.VENDOR_ID
AND MOH.TRANSPORTER_VENDOR_SITE_ID!=AIA.VENDOR_SITE_ID
--AND APS.VENDOR_ID=APSA.VENDOR_ID
--AND MOH.TRANSPORTER_VENDOR_ID=APS.VENDOR_ID
--AND MOH.TRANSPORTER_VENDOR_SITE_ID=APSA.VENDOR_SITE_ID
--AND MOH.READY_FOR_INVOICE='Y'
--AND MOH.AP_FLAG='Y'
AND MOH.TRANSPORTER_VENDOR_ID='4196'
AND MOH.TRANSPORTER_VENDOR_SITE_ID='836708'
--AND MOH.MOV_ORDER_NO='MO/SCOU/1076923'
/* IN ('MO/SCOU/1072707',
'MO/SCOU/1073299',
'MO/SCOU/1073629',
'MO/SCOU/1073860',
'MO/SCOU/1074202',
'MO/SCOU/1074499',
'MO/SCOU/1074891',
'MO/SCOU/1075142',
'MO/SCOU/1075813',
'MO/SCOU/1075929',
'MO/SCOU/1076923',
'MO/SCOU/1077719',
'MO/SCOU/1078232',
'MO/SCOU/1079375',
'MO/SCOU/1080103',
'MO/SCOU/1080341',
'MO/SCOU/1080888',
'MO/SCOU/1081326',
'MO/SCOU/1081936',
'MO/SCOU/1083545',
'MO/SCOU/1075760',
'MO/SCOU/1076447',
'MO/SCOU/1076845',
'MO/SCOU/1077446',
'MO/SCOU/1078383',
'MO/SCOU/1080157',
'MO/SCOU/1080322',
'MO/SCOU/1082740',
'MO/SCOU/1082988',
'MO/SCOU/1083713',
'MO/SCOU/1084182',
'MO/SCOU/1086195',
'MO/SCOU/1087630',
'MO/SCOU/1088347',
'MO/SCOU/1088575',
'MO/SCOU/1089136',
'MO/SCOU/1090178',
'MO/SCOU/1091515',
'MO/SCOU/1092734',
'MO/SCOU/1093721',
'MO/SCOU/1094473',
'MO/SCOU/1094583',
'MO/SCOU/1094631',
'MO/SCOU/1094842',
'MO/SCOU/1095240',
'MO/SCOU/1095706',
'MO/SCOU/1096068',
'MO/SCOU/1072238',
'MO/SCOU/1073298',
'MO/SCOU/1073559',
'MO/SCOU/1073803',
'MO/SCOU/1074138',
'MO/SCOU/1074486',
'MO/SCOU/1074878',
'MO/SCOU/1075246',
'MO/SCOU/1076439',
'MO/SCOU/1076893',
'MO/SCOU/1078384',
'MO/SCOU/1079690',
'MO/SCOU/1080339',
'MO/SCOU/1081227',
'MO/SCOU/1081935',
'MO/SCOU/1083506',
'MO/SCOU/1083767',
'MO/SCOU/1084174',
'MO/SCOU/1085709',
'MO/SCOU/1086792',
'MO/SCOU/1087375',
'MO/SCOU/1088620',
'MO/SCOU/1089528',
'MO/SCOU/1093720',
'MO/SCOU/1094474',
'MO/SCOU/1094584',
'MO/SCOU/1095286',
'MO/SCOU/1096323') */
--AND APS.SEGMENT1='3062'
--AND TO_CHAR(APS.SEGMENT1)=TO_CHAR(:P_TRANSPORTER_NUMBER)
--AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE AIA.INVOICE_NUM=MOH.MOV_ORDER_NO)
--AND EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE AIA.INVOICE_NUM=MOH.MOV_ORDER_NO AND )
