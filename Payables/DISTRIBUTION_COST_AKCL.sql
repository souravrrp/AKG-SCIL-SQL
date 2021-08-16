---------------------------------------MO----------------------------------------------------


SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
SUM(AIDA.AMOUNT) AMOUNT,
(SELECT SUM(DECODE (DODL.UOM_CODE, 'MTN', DODL.LINE_QUANTITY*20,
                                        'BAG', DODL.LINE_QUANTITY)) QTY FROM APPS.XXAKG_DEL_ORD_DO_LINES DODL WHERE DODL.DO_HDR_ID=MOH.DO_HDR_ID) TOTAL_QUANTITY_BAG,
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
and AIDA.ATTRIBUTE15=MOH.DO_HDR_ID
        AND aia.invoice_id=AIDA.invoice_id
        AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
       AND aia.org_id = 85
--       AND aia.invoice_num='MO/SCOU/1031169'
--       AND gcc.segment2='GHAT21'
--       AND TO_CHAR (mOH.mov_order_date, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='MAR-18'
       AND MOH.VEHICLE_TYPE='Owned By Company'
--       AND MOH.TRANSPORT_MODE='Company Bulk Carrier'
group by
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
MOH.DO_HDR_ID,
MOH.DO_QUANTITY,
aia.invoice_num,
TO_CHAR (MOH.CONFIRMED_DATE),
MOH.WAREHOUSE_ORG_CODE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO


------------------------------MTO----------------------------------------


SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
SUM(AIDA.AMOUNT) AMOUNT,
SUM(DECODE (TDL.UOM_CODE, 'MTN', TDL.QUANTITY*20,
                                        'BAG', TDL.QUANTITY)) "TOTAL_QUANTITY_BAG",
aia.invoice_num Move_number,
TO_CHAR (TMH.MOV_ORDER_DATE) MOVE_Order_DATE,
TMH.FROM_INV WAREHOUSE,
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
--       AND TMH.MOV_ORDER_NO=:P_MOV_ORDER_NO
--       AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='MAR-18'
--       AND gcc.segment2='GHAT21'
AND TMH.VEHICLE_TYPE='Owned By Company'
--       AND TMH.TRANSPORT_MODE='Company Truck'
GROUP BY
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
aia.invoice_num,
TO_CHAR (TMH.MOV_ORDER_DATE),
TMH.FROM_INV,
TMH.TRANSPORT_MODE
,TMH.VEHICLE_NO



------------------------------------summary----------------------------------

SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 "ACCOUNT_COMBINATION"
,SUM(AIDA.AMOUNT) AMOUNT
--,AIA.INVOICE_NUM
--,AIDA.*
  FROM apps.ap_invoices_all aia
  ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
  ,apps.gl_code_combinations gcc
WHERE 1=1
AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
        AND aia.invoice_id=AIDA.invoice_id
--        AND INVOICE_TYPE_LOOKUP_CODE='STANDARD'
       AND aia.org_id = 85
--       and aia.invoice_num=:P_INVOICE_NUMBER
       AND AIA.SOURCE IN ('AKG TRIP INVOICE','AKG TRIP INVOICE TO')
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='MAR-18'
--       AND AIDA.PERIOD_NAME='FEB-18'
--        AND gcc.segment2='GHAT21'
        AND gcc.segment3 IN ('4031901','4031902','4031903')       
group by
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5
--,AIA.INVOICE_NUM
ORDER BY ACCOUNT_COMBINATION



-----------------------------------------------DUMMY-------------------------------------------
SELECT 
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 ACCOUNT_COMBINATION,
aia.INVOICE_AMOUNT AMOUNT,
SUM(DECODE (DODL.UOM_CODE, 'MTN', DODL.LINE_QUANTITY*20,
                                        'BAG', DODL.LINE_QUANTITY)) "QUANTITY",
aia.invoice_num Move_number,
TO_CHAR (MOH.CONFIRMED_DATE) mOVE_CONFIRMED_DATE,
MOH.WAREHOUSE_ORG_CODE WAREHOUSE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO
--,aia.*
  FROM apps.ap_invoices_all aia
  ,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
  ,apps.gl_code_combinations gcc
       ,XXAKG.XXAKG_MOV_ORD_HDR MOH
       ,APPS.XXAKG_DEL_ORD_DO_LINES DODL
,XXAKG.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND AIA.SOURCE IN ('AKG TRIP INVOICE')
AND aia.invoice_num=MOH.MOV_ORDER_NO
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND modt.DO_HDR_ID=DODL.DO_HDR_ID
AND Dodl.DO_NUMBER=MODT.DO_NUMBER
        AND aia.invoice_id=AIDA.invoice_id
        AND AIDA.DIST_CODE_COMBINATION_ID=gcc.code_combination_id
       AND aia.org_id = 85
--       AND gcc.segment2='GHAT21'
--       AND TO_CHAR (mOH.mov_order_date, 'MON-RR') = 'FEB-18'
--       AND TO_CHAR(aIa.GL_DATE,'MON-RR')='FEB-18'
       AND TO_CHAR(AIDA.accounting_date,'MON-RR')='FEB-18'
       AND MOH.VEHICLE_TYPE='Owned By Company'
--       AND MOH.TRANSPORT_MODE='Company Truck'
group by
gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5,
aia.INVOICE_AMOUNT,
aia.invoice_num,
TO_CHAR (MOH.CONFIRMED_DATE),
MOH.WAREHOUSE_ORG_CODE,
MOH.TRANSPORT_MODE
,MOH.VEHICLE_NO



---------------------------------------------Others-------------------------------------------
select
SUM(DECODE (dl.UOM_CODE, 'MTN', dl.LINE_QUANTITY*20,
                                        'BAG', dl.LINE_QUANTITY)) "TOTAL_QUANTITY_BAG"
from
apps.xxakg_mov_ord_hdr mh,apps.xxakg_mov_ord_dtl md,
apps.xxakg_del_ord_hdr dh,apps.xxakg_del_ord_do_lines dl,
apps.xxakg_distributor_block_m dbm
where mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and md.do_hdr_id=dh.do_hdr_id
and dh.do_hdr_id=dl.do_hdr_id
AND mh.VEHICLE_TYPE='Owned By Company'
and dh.customer_number=dbm.customer_number(+)
--and mh.ready_for_invoice='Y'
AND mh.ap_flag IS NULL
--AND not exists(select 1 from apps.ap_invoices_all aia, apps.xxakg_mov_ord_hdr moh where  moh.MOV_ORDER_NO=AIA.INVOICE_NUM )
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh, APPS.WSH_DELIVERABLES_V WSHD where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id   and oh.order_type_id=1099 AND OL.HEADER_ID = WSHD.SOURCE_HEADER_ID and wshd.released_status='C'  AND TO_CHAR (ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-18')
and mh.org_id=85
--and mh.gate_out='Y'
--and mh.gate_in IS NULL--='Y'
--and dl.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'


select
SUM(DECODE (TDL.UOM_CODE, 'MTN', TDL.QUANTITY*20,
                                        'BAG', TDL.QUANTITY)) "TOTAL_QUANTITY_BAG"
from
XXAKG.XXAKG_TO_MO_HDR TMH
       ,XXAKG.XXAKG_TO_DO_LINES TDL
       ,APPS.XXAKG_TO_MO_DTL TMD
where TMD.TO_HDR_ID=TDL.TO_HDR_ID
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
--and mh.ready_for_invoice='Y'
AND TMH.ap_flag IS NULL
--AND not exists(select 1 from apps.ap_invoices_all aia, apps.xxakg_mov_ord_hdr moh where  moh.MOV_ORDER_NO=AIA.INVOICE_NUM )
--and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh, APPS.WSH_DELIVERABLES_V WSHD where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id   and oh.order_type_id=1099 AND OL.HEADER_ID = WSHD.SOURCE_HEADER_ID and wshd.released_status='C'  AND TO_CHAR (ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-18')
and TMH.org_id=85
AND TO_CHAR(TMD.confirm_date,'MON-RR')='MAR-18'
AND TMH.VEHICLE_TYPE='Owned By Company'
--and mh.gate_out='Y'
--and mh.gate_in IS NULL--='Y'
--and dl.warehouse_org_code='SCI'
and TMH.mov_order_status='CONFIRMED'

select
*
from
XXAKG.XXAKG_TO_MO_HDR TDL
where 1=1
order by last_update_date desc