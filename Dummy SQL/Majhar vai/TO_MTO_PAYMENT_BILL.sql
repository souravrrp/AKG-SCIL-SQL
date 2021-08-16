SELECT 
--mhdr.MOV_ORD_HDR_ID,
          mhdr.ORG_ID,
          mhdr.MOV_ORDER_NO,
--          mhdr.MOV_ORDER_DATE,
          mhdr.MOV_ORDER_STATUS,
--          mhdr.MOV_ORDER_TYPE,
          mhdr.FINAL_DESTINATION,
--          mhdr.FROM_INV,
--          mhdr.TRANSPORT_MODE,
          mhdr.VEHICLE_NO,
--          mhdr.GATE_OUT,
--          mhdr.GATE_OUT_DATE,
--          mhdr.GATE_IN,
--          mhdr.GATE_IN_DATE,
--          mhdr.CREATION_DATE,
--          mhdr.CREATED_BY,
--          mhdr.LAST_UPDATE_DATE,
--          mhdr.LAST_UPDATED_BY,
--          mhdr.VEHICLE_TYPE,
          mhdr.TRANSPORTER_NAME,
          mhdr.TRANSPORTER_VENDOR_ID,
          mhdr.TRANSPORTER_VENDOR_SITE_ID,
--          mhdr.INITIAL_GATE_IN,
--          mhdr.INITIAL_GATE_IN_DATE,
--          mhdr.EMPTY_TRUCK_WT,
--          mhdr.EMPTY_TRUCK_WT_DATE,
--          mhdr.DRIVER_NAME,
--          mhdr.DRIVER_MOBILE,
--          mhdr.FULL_TRUCK_WT,
--          mhdr.FULL_TRUCK_WT_DATE,
          mhdr.HIRE_RATE_AP,
          mhdr.HIRE_RATE_AR,
          mdtl.TO_NUMBER TRANSFER_ORDER_NO,
--          mdtl.TO_INV,
          mdtl.CONFIRM_DATE,
--          mdtl.TRANSFER_LOADING_DATE,
--          mdtl.TRUCK_LOADING_DATE,
--          mdtl.VAT_RECEIVED_DATE,
          mdtl.VAT_CHALLAN_NO,
--          mdtl.VAT_CHALLAN_DATE,
--          mdtl.VAT_IN_DATE,
          thdr.TO_STATUS,
          thdr.OPERATING_UNIT,
--          thdr.TO_DATE TRANSFER_ORDER_DATE,
--          thdr.MODE_OF_TRANSPORT,
--          thdr.TRANSFER_DATE,
--          thdr.HAND_OVER_DATE,
--          thdr.DELIVERY_MODE,
          thdr.CUSTOMER_ID,
          thdr.CUSTOMER_NAME,
          tlin.ITEM_NUMBER,
          tlin.ITEM_DESCRIPTION,
          tlin.QUANTITY,
          tlin.UOM_CODE,
          tlin.FROM_SUBINV,
          tlin.TO_SUBINV,
--          tlin.REMARKS,
--          tlin.REMARKS_DATE,
--          tlin.TERRITORY,
          tlin.FROM_ORGANIZATION_ID,
          tlin.TO_ORGANIZATION_ID
     --decode (ITEM_NUMBER,'CMNT.SBAG.0001', 'SPECIAL','CMNT.PBAG.0001', 'POPULER') ITEM_GROUP
     FROM XXAKG.XXAKG_TO_MO_HDR mhdr,
          XXAKG.XXAKG_TO_MO_DTL mdtl,
          XXAKG.XXAKG_TO_DO_HDR thdr,
          XXAKG.XXAKG_TO_DO_LINES tlin
    WHERE     mhdr.MOV_ORD_HDR_ID = mdtl.MOV_ORD_HDR_ID
          AND mdtl.TO_HDR_ID = thdr.TO_HDR_ID(+)
          AND thdr.TO_HDR_ID = tlin.TO_HDR_ID(+)
          AND mhdr.MOV_ORDER_NO='MTO/SCOU/047737'
          
          
          
          
          
          SELECT distinct
aia.ORG_ID,
APS.SEGMENT1 vendor_NUMBER,
aps.VENDOR_NAME,
--cust_acct.ACCOUNT_NUMBER CUTOMER_NUMBER,
--party.party_name CUSTOMER_NAME,
--DECODE (RTT.TYPE, 'PMT', 'PAYMENT', 
--                             'CM', 'CREDIT MEMO', 
--                             'INV', 'INVOICES', 
--                             'DM', 'DEBIT MEMO',
--                                'Not Defined') "PAYMENT TYPE",
aia.invoice_num,
aia.INVOICE_AMOUNT,
aia.invoice_date,
aia.invoice_type_lookup_code,
AIA.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
TO_CHAR(aia.GL_DATE) GL_DATE,
aia.description,
--aia.cancelled_date,
gcc.segment2 "Cost Centre" ,
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 "Account",
gcc.segment3 "Natural Account",
--cust_acct.ACCOUNT_NAME,
--apsa.TRX_NUMBER,
--apsa.TRX_DATE,
--loc.ADDRESS1 ADDRESS,
--fndu.user_name user_id
aila.OVERLAY_DIST_CODE_CONCAT,
aila.DESCRIPTION Line_description,
aipa.accounting_date,
aipa.amount Payment_amount,
aipa.period_name,
aipa.bank_account_num, 
apsa.GROSS_AMOUNT, 
apsa.PAYMENT_STATUS_FLAG, 
apsa.HOLD_FLAG, 
apsa.PAYMENT_METHOD_CODE,
aca.AMOUNT CHECK_AMOUNT,  
aca.BANK_ACCOUNT_NAME, 
aca.CHECK_DATE
,assa.ADDRESS_LINE1 ADDRESS
,fndu.user_name user_id
,TMH.*
  FROM apps.ap_invoices_all aia,
  apps.ap_invoice_lines_all aila,
       apps.ap_suppliers aps,
       apps.ap_supplier_sites_all assa,
       apps.ap_payment_schedules_all apsa,
       apps.ap_invoice_payments_all aipa,
       apps.ap_checks_all aca
       ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
       ,apps.gl_code_combinations gcc
       ,apps.fnd_user fndu
       ,APPS.XXAKG_TO_MO_HDR TMH
WHERE 1=1
        AND aia.invoice_id=aila.invoice_id
        and aia.vendor_id = aps.vendor_id
       AND aia.vendor_site_id = assa.vendor_site_id
       AND aps.vendor_id = assa.vendor_id
       AND aia.invoice_id = apsa.invoice_id
       AND aipa.invoice_id = aia.invoice_id
       AND aca.CHECK_ID = aipa.CHECK_ID
       and AIA.INVOICE_ID=AIDA.INVOICE_ID
       and aipa.ACCTS_PAY_CODE_COMBINATION_ID=gcc.code_combination_id
       and fndu.user_id=aia.LAST_UPDATED_BY
       AND TMH.MOV_ORDER_NO= AIA.INVOICE_NUM
       AND TMH.TRANSPORTER_VENDOR_ID=aia.vendor_id
       AND TMH.TRANSPORTER_VENDOR_SITE_ID=aia.vendor_site_id
       and aca.STATUS_LOOKUP_CODE <> 'VOIDED'
       AND aia.org_id = 85
--       AND TMH.MOV_ORDER_NO='MTO/SCOU/047737'
       AND AIA.INVOICE_NUM='MTO/SCOU/047737'--'MO/SCOU/966557'--
--where INVOICE_TYPE_LOOKUP_CODE not IN ('MIXED','CREDIT','PREPAYMENT','STANDARD','PAYMENT REQUEST','DEBIT','EXPENSE REPORT')
--       AND ac.check_date BETWEEN TO_DATE ('01-Apr-2014', 'DD-MON-YYYY') AND TO_DATE ('30-Jun-2014 23:59:59', 'DD-MON-YYYY HH24:MI:SS')

       
SELECT DISTINCT aiLa.*-- distinct
/* aia.VENDOR_SITE_ID,
aia.VENDOR_ID,
aia.PARTY_ID,
aia.PARTY_SITE_ID
,aia.*
,TMH.TRANSPORTER_VENDOR_ID
,TMH.TRANSPORTER_VENDOR_SITE_ID*/
FROM
APPS.ap_invoices_all aia,
  apps.ap_invoice_lines_all aila,
  APPS.XXAKG_TO_MO_HDR TMH
  ,XXAKG.XXAKG_TO_MO_DTL tmd
WHERE 1=1
AND aia.invoice_id=aila.invoice_id
and TMH.MOV_ORD_HDR_ID = tmd.MOV_ORD_HDR_ID
AND TMH.MOV_ORDER_NO= AIA.INVOICE_NUM
AND TMH.TRANSPORTER_VENDOR_ID=aia.vendor_id
AND TMH.TRANSPORTER_VENDOR_SITE_ID=aia.vendor_site_id
and TMH.MOV_ORDER_NO='MTO/SCOU/047737'

select
*
from
XXAKG.XXAKG_TO_MO_DTL

   
SELECT
TDH.CUSTOMER_NAME,
TDH.TO_NUMBER,
TMH.MOV_ORDER_NO,
AIA.INVOICE_NUM,
AIA.INVOICE_AMOUNT,
AIA.CREATION_DATE,
--TDL.QUANTITY,
SUM(TDL.QUANTITY) TO_QUANTITY,
TO_CHAR (AIA.CREATION_DATE, 'DD-MON-YYYY') INVOICE_DATE
,AIA.DOC_SEQUENCE_VALUE
,AILA.AMOUNT
--,aila.description
FROM
XXAKG.XXAKG_TO_MO_HDR TMH,
XXAKG.XXAKG_TO_MO_DTL TMD,
XXAKG.XXAKG_TO_DO_HDR TDH,
XXAKG.XXAKG_TO_DO_LINES TDL
,APPS.AP_INVOICES_ALL AIA
,APPS.AP_INVOICE_LINES_ALL AILA
WHERE 1=1
AND TMH.MOV_ORD_HDR_ID = TMD.MOV_ORD_HDR_ID
AND TMD.TO_HDR_ID = TDH.TO_HDR_ID
AND TDH.TO_HDR_ID = TDH.TO_HDR_ID
AND TMH.MOV_ORDER_NO=AIA.INVOICE_NUM
AND AIA.INVOICE_ID=AILA.INVOICE_ID
AND TMH.TRANSPORTER_VENDOR_ID=aia.vendor_id
AND TMH.TRANSPORTER_VENDOR_SITE_ID=aia.vendor_site_id
--AND TDH.WAREHOUSE_ORG_CODE='SCI'
AND AIA.INVOICE_NUM='MTO/SCOU/047737'
--AND AIA.CREATION_DATE BETWEEN '15-OCT-2017' and '16-OCT-2017'
--AND DOH.CUSTOMER_NUMBER IN ('20107','20770','184363')
GROUP BY
TDH.CUSTOMER_NAME,
TDH.TO_NUMBER,
TMH.MOV_ORDER_NO,
AIA.INVOICE_NUM,
AIA.INVOICE_AMOUNT,
AIA.CREATION_DATE
,AIA.DOC_SEQUENCE_VALUE
,AILA.invoice_id
,aila.AMOUNT