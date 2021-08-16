SELECT 
STATUS,
FU.MOVE_ORDER_NO,
FU.VEHICLE_NUMBER,
FU.DRIVER_ID,
FU.DRIVER_NAME,
DISTANCE_KM,
KPL,
NVL(ESTIMATED_FUEL,0) ESTIMATED_FUEL,
NVL(ADJUSTED_AMOUNT,0) ADJUSTED_AMOUNT,
NVL(SPECIAL_ADVANCE,0) SPECIAL_ADVANCE,
NVL(PREVIOUS_REMAIN_FUEL,0) PREVIOUS_REMAIN_FUEL,
'['||DISTANCE_KM||'/'||KPL||'] '||NVL(ESTIMATED_FUEL,0)||'+('||NVL(ADJUSTED_AMOUNT,0) ||')+('||NVL(SPECIAL_ADVANCE,0)||')-('||NVL(PREVIOUS_REMAIN_FUEL,0)||')= '||
(ESTIMATED_FUEL+NVL(ADJUSTED_AMOUNT,0)+NVL(SPECIAL_ADVANCE,0))||'-('||NVL(PREVIOUS_REMAIN_FUEL,0)||')= '||PROVIDED_FUEL CALCULATED_PF,
NVL(PROVIDED_FUEL,0) ACTUAL_PROVIDED_FUEL,
FUEL_BLANCE OUTPUMP_QUANTITY,
NVL(ACCTUAL_CONSUMPTION,0) ACCTUAL_CONSUMPTION,
'('||PROVIDED_FUEL||'+'||FUEL_BLANCE||'-'||ACCTUAL_CONSUMPTION||') ='||(NVL(PROVIDED_FUEL,0)+NVL(FUEL_BLANCE,0)-NVL(ACCTUAL_CONSUMPTION,0)) CALCULATED_RF,
TRIP_REMAINING,
REMAINING_FUEL 
--,FU.*
FROM APPS.XXAKG_FUEL_MAINTANANCE FU
WHERE 1=1
AND FU.ORGANIZATION_ID=84   -- IN (84,82)
--AND FU.DRIVER_ID=33701
--AND STATUS='TRANSACTED'
--AND FU.COST_CENTER!='FCTRK'
--AND FU.VEHICLE_NUMBER LIKE '%1473%'
AND FU.MOVE_ORDER_NO LIKE '%MO/RMCOU/130162%'
--AND FU.MOVE_ORDER_NO IS NULL
--AND TO_CHAR(FU.MO_DATE,'RRRR')='2019'
--AND TO_CHAR(FU.MO_DATE,'MON-RR')='DEC-17'
--AND TO_CHAR(FU.MO_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/NOV/28 18:00:00' AND '2018/NOV/29 09:00:00'--HH:MI:SS--12:00:00
--AND EXISTS(SELECT 1 FROM XXAKG.XXAKG_MOV_ORD_HDR MOH WHERE FU.MOVE_ORDER_NO=MOH.MOV_ORDER_NO AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier') )    --'Company Truck'
ORDER BY MO_DATE DESC



------------------------------------------------------------------------------------------------

SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
SUM(AIDA.AMOUNT) AMOUNT,
(SELECT SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', OOL.ORDERED_QUANTITY*20,
'BAG', OOL.ORDERED_QUANTITY)) QTY 
FROM APPS.OE_ORDER_LINES_ALL OOL 
WHERE ool.shipment_priority_code=(select do_number from apps.xxakg_del_ord_hdr where org_id=85 and do_hdr_id=to_number(AIDA.ATTRIBUTE15)) 
AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-18' 
and nvl(ool.shipped_quantity,0)<>0
) TOTAL_QUANTITY_BAG,
aia.invoice_num Move_number,
TO_CHAR (MOH.CONFIRMED_DATE) mOVE_CONFIRMED_DATE,
MOH.WAREHOUSE_ORG_CODE WAREHOUSE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO
--,AIDA.*
FROM apps.ap_invoices_all aia
,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
,apps.gl_code_combinations gcc
,XXAKG.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND AIA.SOURCE IN ('AKG TRIP INVOICE')
AND aia.invoice_num=MOH.MOV_ORDER_NO
AND aia.invoice_id=AIDA.invoice_id
AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
AND aia.org_id = 85
and MOH.WAREHOUSE_ORG_CODE='SCI'
-- AND aia.invoice_num='MO/SCOU/1031169'
-- AND gcc.segment2='GHAT21'
-- AND TO_CHAR (mOH.mov_order_date, 'MON-RR') = 'FEB-18'
-- AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
AND TO_CHAR(AIDA.accounting_date,'MON-RR')='MAR-18'
AND MOH.VEHICLE_TYPE='Owned By Company'
AND MOH.TRANSPORT_MODE='Company Bulk Carrier'
group by
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
aia.invoice_num,
TO_CHAR (MOH.CONFIRMED_DATE),
MOH.WAREHOUSE_ORG_CODE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO
,AIDA.ATTRIBUTE15



---------------------


SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
SUM(AIDA.AMOUNT) AMOUNT,
(SELECT SUM(DECODE (OOL.ORDER_QUANTITY_UOM, 'MTN', OOL.SHIPPED_QUANTITY*20,
                                        'BAG', OOL.SHIPPED_QUANTITY)) QTY FROM APPS.XXAKG_DEL_ORD_HDR DOH, APPS.OE_ORDER_LINES_ALL OOL WHERE DOH.DO_HDR_ID=AIDA.ATTRIBUTE15 AND DOH.DO_NUMBER=OOL.SHIPMENT_PRIORITY_CODE
                                        AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-18' ) TOTAL_QUANTITY_BAG,
aia.invoice_num Move_number,
TO_CHAR (MOH.CONFIRMED_DATE) mOVE_CONFIRMED_DATE,
MOH.WAREHOUSE_ORG_CODE WAREHOUSE,
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
--and AIDA.ATTRIBUTE15=MOH.DO_HDR_ID
        AND aia.invoice_id=AIDA.invoice_id
        AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
       AND aia.org_id = 85
       and MOH.WAREHOUSE_ORG_CODE='SCI'
--       AND aia.invoice_num='MO/SCOU/1031169'
--       AND gcc.segment2='GHAT21'
--       AND TO_CHAR (mOH.mov_order_date, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='MAR-18'
       AND MOH.VEHICLE_TYPE='Owned By Company'
       AND MOH.TRANSPORT_MODE='Company Bulk Carrier'
group by
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
aia.invoice_num,
TO_CHAR (MOH.CONFIRMED_DATE),
MOH.WAREHOUSE_ORG_CODE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO
,AIDA.ATTRIBUTE15  
                
---------------------------------------Officer Phone Number--------------------------------------------------------------

SELECT DISTINCT
--HP.*,
CA.ACCOUNT_NUMBER CUSTOMER_NUMBER,
HP.PARTY_NAME CUSTOMER_NAME,
CA.ATTRIBUTE9 "Officer Phone Number"
--CA.ACCOUNT_NAME,
--CA.STATUS ACCOUNT_STATUS,
--CSUA.STATUS CUSTOMER_SITE_STATUS,
--CA.CREATION_DATE "ACCOUNT CREATION DATE",
--CASA.CREATION_DATE "ACCOUNT SITE CREATION DATE",
--CSUA.SITE_USE_CODE,
--CSUA.LOCATION
FROM
APPS.HZ_CUST_ACCOUNTS CA,
APPS.HZ_PARTIES HP,
APPS.HZ_CUST_SITE_USES_ALL CSUA,
APPS.HZ_CUST_ACCT_SITES_ALL CASA
WHERE 1=1
AND CA.PARTY_ID=HP.PARTY_ID
--AND CA.ORIG_SYSTEM_REFERENCE=CSUA.ORIG_SYSTEM_REFERENCE
AND CSUA.CUST_ACCT_SITE_ID=CASA.CUST_ACCT_SITE_ID
AND CA.CUST_ACCOUNT_ID=CASA.CUST_ACCOUNT_ID
--AND CA.STATUS='A'
--AND CSUA.STATUS='A'
AND CA.ATTRIBUTE9 IN ('01975441919','01817292822')
AND CSUA.SITE_USE_CODE='BILL_TO'

------------------------------------------------------------------------------------------------

SELECT MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE) TRANSACTION_DATE,
                            MMT.TRANSACTION_UOM,
                            SUM (
                               -1 * MMT.TRANSACTION_QUANTITY
                               * APPS.INV_CONVERT.INV_UM_CONVERT (
                                    MMT.INVENTORY_ITEM_ID,
                                    MMT.TRANSACTION_UOM,'PCS'
--                                    P_UOM
                                    ))
                               PRIMARY_QUANTITY
                       FROM APPS.mtl_material_transactions MMT,
                            APPS.MTL_TRANSACTION_TYPES MTT,
                            APPS.MTL_TXN_REQUEST_LINES MTRL,
                            APPS.MTL_TXN_REQUEST_HEADERS MTRH
                      WHERE     1 = 1
                            AND MTRH.HEADER_ID = MTRL.HEADER_ID
                            AND MMT.INVENTORY_ITEM_ID = MTRL.INVENTORY_ITEM_ID
                            AND MMT.INVENTORY_ITEM_ID = '168051'--P_INVENTORY_ITEM_ID
                            AND MMT.TRANSACTION_SOURCE_ID = MTRH.HEADER_ID
                            AND MMT.TRX_SOURCE_LINE_ID = MTRL.LINE_ID
                            AND MTRH.ATTRIBUTE_CATEGORY = 'AKCL Vehicle Number'
                            AND MTRH.ATTRIBUTE1 = 'D.M.U-11-2046'--P_UOA
                            AND MMT.TRANSACTION_DATE < '17-FEB-19'--TRUNC (P_DATE_REQUIRED)
                            --AND MMT.INVENTORY_ITEM_ID in (178138)--, 72699,73714,49053,57343,56370,50792)
                            AND MMT.ORGANIZATION_ID in (89,1306)
                            AND MMT.TRANSACTION_TYPE_ID =
                                   MTT.TRANSACTION_TYPE_ID
                            AND MTT.TRANSACTION_TYPE_NAME = 'Move Order Issue'
                   GROUP BY MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE),
                            MMT.TRANSACTION_UOM
                   ORDER BY TRUNC (MMT.TRANSACTION_DATE) DESC
                   
SELECT MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE) TRANSACTION_DATE,
                            MMT.TRANSACTION_UOM,
                            SUM (
                               -1 * MMT.TRANSACTION_QUANTITY
                               * APPS.INV_CONVERT.INV_UM_CONVERT (
                                    MMT.INVENTORY_ITEM_ID,
                                    MMT.TRANSACTION_UOM,'PCS'
--                                    P_UOM
                                    ))
                               PRIMARY_QUANTITY
                       FROM APPS.mtl_material_transactions MMT,
                            APPS.MTL_TRANSACTION_TYPES MTT,
                            APPS.MTL_TXN_REQUEST_LINES MTRL,
                            APPS.MTL_TXN_REQUEST_HEADERS MTRH
                      WHERE     1 = 1
                            AND MTRH.HEADER_ID = MTRL.HEADER_ID
                            AND MMT.INVENTORY_ITEM_ID = MTRL.INVENTORY_ITEM_ID
                            AND MMT.INVENTORY_ITEM_ID = '168051'--P_INVENTORY_ITEM_ID
                            AND MMT.TRANSACTION_SOURCE_ID = MTRH.HEADER_ID
                            AND MMT.TRX_SOURCE_LINE_ID = MTRL.LINE_ID
                            AND MTRH.ATTRIBUTE_CATEGORY = 'AKCL Vehicle Number'--P_ATC
                            AND NVL(MTRH.ATTRIBUTE1,MTRH.ATTRIBUTE4) = 'D.M.U-11-2046'--P_UOA
                            AND MMT.TRANSFER_ORGANIZATION_TYPE IS NULL
                            --AND MMT.TRANSACTION_DATE < TRUNC (P_DATE_REQUIRED)
                            and to_char(MMT.TRANSACTION_DATE,'DD-MON-YYYY') < '17-FEB-19'--P_DATE_REQUIRED
                            --AND MMT.INVENTORY_ITEM_ID in (178138)--, 72699,73714,49053,57343,56370,50792)
                            --AND MMT.ORGANIZATION_ID in (89,1306)
                            AND MMT.ORGANIZATION_ID = 1306--P_ORG
                            AND MMT.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
                            AND MMT.TRANSACTION_QUANTITY<0
                            --AND MTT.TRANSACTION_TYPE_NAME = 'Move Order Issue'
                   GROUP BY MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE),
                            MMT.TRANSACTION_UOM
                   ORDER BY TRUNC (MMT.TRANSACTION_DATE) DESC