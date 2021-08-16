select 'Move Order' Inoice_Status,
mh.mov_order_no,
to_char(mh.mov_order_date) mov_order_date,
mh.warehouse_org_code org_code,
(case 
          when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
            else sum(decode (ool.order_quantity_uom, 'MTN', ool.ordered_quantity*20,'BAG', ool.ordered_quantity))
end) "Quantity in BAG",
sum(ool.ordered_quantity) quantity,
mh.final_destination,
mh.transport_mode,
mh.hire_rate_ap,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice
,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and mh.mov_order_type='RELATED'
and ool.pricing_quantity_uom in ('BAG','MTN')
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
--and to_char(ool.actual_shipment_date,'MON-RR')='AUG-18'
and to_char(ool.actual_shipment_date,'RRRR')='2019'
--and ool.actual_shipment_date<='30-JUN-2019'
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is not null 
and mh.hire_rate_ap!='0'
and mh.ap_flag is null
and ool.flow_status_code in ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
group by
--md.customer_number,
mh.mov_order_no,
mh.mov_order_date,
mh.final_destination,
mh.warehouse_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
,ool.ordered_item
union all
select 'Move Transfer Order' Inoice_Status,
tmh.mov_order_no,
to_char(tmh.mov_order_date) mov_order_date,
tmh.from_inv org_code,
(CASE 
          WHEN  tdl.item_number='CMNT.OBAG.0004' THEN (SUM(tdl.quantity)*1000)/50
            ELSE SUM(DECODE (tdl.uom_code, 'MTN', tdl.quantity*20,'BAG', tdl.quantity))
END) "Quantity in BAG",
sum(tdl.quantity) quantity,
tmh.final_destination,
tmh.transport_mode,
Tmh.hire_rate_ap,
tmh.gate_out,
tmh.gate_in,
'Y' ready_for_invoice
,tmh.ap_flag
from
apps.xxakg_to_mo_hdr tmh 
,apps.xxakg_to_mo_dtl tmd
,xxakg.xxakg_to_do_lines tdl
where 1=1
and tmd.mov_ord_hdr_id=tmh.mov_ord_hdr_id
and tdl.to_hdr_id=tmd.to_hdr_id
and tdl.uom_code IN ('BAG','MTN')
AND SUBSTR(tdl.ITEM_NUMBER,0,4)='CMNT'
and tmh.mov_order_type='RELATED'
--and TMH.VEHICLE_TYPE='Rented'
and tmh.org_id=85
--and TMH.GATE_OUT='Y'
and tmh.gate_in='Y'
and tmh.hire_rate_ap is not null 
and tmh.hire_rate_ap!='0'
and tmh.ap_flag is null
--AND TMH.MOV_ORDER_DATE BETWEEN '01-JAN-2016' and '30-JUN-2018'
--and tmh.mov_order_date<='20-JUN-2019' 
and tmh.mov_order_status='CONFIRMED'
--and mh.transport_mode='Company Truck'
--AND TO_CHAR (mh.MOV_ORDER_DATE, 'MON-RR') = 'OCT-17'
--AND TRUNC(TMH.mov_order_date) BETWEEN NVL(:P_DATE_FROM,TRUNC(TMH.mov_order_date)) AND NVL(:P_DATE_TO,TRUNC(TMH.mov_order_date))
--AND TMH.VEHICLE_NO!='SCIL-SCM-0001'
--and TMH.FROM_INV='SCI'
--and TMH.transport_mode IN ('Rental Barge')
--AND TMH.MOV_ORDER_NO='MTO/SCOU/052022'
--AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE TMH.MOV_ORDER_NO=AIA.INVOICE_NUM)
and exists (select 1 from apps.xxakg_to_do_hdr tdh where tdh.to_hdr_id=tmd.to_hdr_id and tdh.to_status='CONFIRMED' )--and to_char(tdh.to_date,'MON-RR')=:P_Period_of_Month)--'MAR-19')--
and exists (select 1 from inv.mtl_material_transactions mmt where mmt.shipment_number=tdl.to_number
--    and to_char(trunc(mmt.transaction_date),'MON-YY') in ('SEP-18')
    and to_char(trunc(mmt.transaction_date),'RRRR') in ('2019')
    --and trunc(mmt.transaction_date)<='30-JUN-2019'
    AND TRUNC(mmt.transaction_date)<=NVL(:P_DATE_UPTO,SYSDATE)
)
group by
--md.customer_number,
tmh.mov_order_no,
tmh.mov_order_date,
tmh.final_destination,
tmh.from_inv,
tmh.transport_mode,
tmh.gate_out,
tmh.gate_in
,tmh.hire_rate_ap
,tmh.ap_flag
,tdl.item_number

--------------------------INVOICE_NOT_CREATE----------------------------------------------
SELECT 
*
FROM
APPS.XXAKG_TRIP_INV_NOT_CREATE_V
WHERE 1=1

--------------------------INVOICE_INTERFACE----------------------------------------------

SELECT
*
FROM
APPS.AP_INVOICES_INTERFACE AII
WHERE 1=1
AND SOURCE='AKG TRIP INVOICE'
AND TO_CHAR(INVOICE_DATE,'MON-RR')='AUG-18'
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
AND ORG_ID=85

------------------------------------------------------------------------------------------------

SELECT *  FROM apps.XXAKG_PENDING_AP_TRIP_INV_V
WHERE 1=1
AND ORG_ID=85
AND TO_CHAR (ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'MAR-18'
AND READY_FOR_INVOICE='Y'
--AND ACTUAL_SHIPMENT_DATE IS NOT NULL


--------------------------------------------------------------------------------

select 
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.mov_order_date) mov_order_date,
mh.mov_order_status,
(CASE 
          WHEN  ool.ordered_item='CMNT.OBAG.0004' THEN (SUM(ool.ordered_quantity)*1000)/50
            ELSE SUM(DECODE (ool.order_quantity_uom, 'MTN', ool.ordered_quantity*20,'BAG', ool.ordered_quantity))
END) "Quantity in BAG",
sum(ool.ordered_quantity) quantity,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
--and to_char(ool.actual_shipment_date,'MON-RR')='AUG-18'
and ool.actual_shipment_date<='20-JUN-2019'
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is not null 
and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
group by
--md.customer_number,
mh.mov_order_no,
mh.mov_order_date,
mh.mov_order_status,
mh.final_destination,
mh.warehouse_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
,ool.ordered_item

-----------------------------------------------------------------------------------------------

select
dbm.region_name,
--mh.mov_ord_hdr_id,
mh.mov_order_no,
mh.mov_order_date,
mh.mov_order_status,
--mh.mov_order_type,
mh.final_destination,
--mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
--dh.do_hdr_id,
--dh.do_status,
--dh.do_number,
--dh.do_date,
dh.customer_number,
dh.customer_name,
--dl.do_number,
--dl.order_number,
--dl.order_header_id,
--dl.order_line_id,
--dl.line_number,
--dl.ordered_item_id,
--dl.item_number,
--dl.item_description,
--dl.line_quantity DO_QUANTITY,
--dl.uom_code,
dl.warehouse_org_code,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.ap_flag,
mh.ar_flag
from
apps.xxakg_mov_ord_hdr mh,apps.xxakg_mov_ord_dtl md,
apps.xxakg_del_ord_hdr dh,apps.xxakg_del_ord_do_lines dl,
apps.xxakg_distributor_block_m dbm
where mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and md.do_hdr_id=dh.do_hdr_id
and dh.do_hdr_id=dl.do_hdr_id
and dh.customer_number=dbm.customer_number(+)
and mh.ready_for_invoice='Y'
AND mh.ap_flag IS NULL
--AND not exists(select 1 from apps.ap_invoices_all aia, apps.xxakg_mov_ord_hdr moh where  moh.MOV_ORDER_NO=AIA.INVOICE_NUM )
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh, APPS.WSH_DELIVERABLES_V WSHD where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id   and oh.order_type_id=1099 AND OL.HEADER_ID = WSHD.SOURCE_HEADER_ID and wshd.released_status='C')
and mh.org_id=85
--and mh.gate_out='Y'
--and mh.gate_in IS NULL--='Y'
--and dl.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TRUNC(mh.mov_order_date) BETWEEN NVL(:P_DATE_FROM,TRUNC(mh.mov_order_date)) AND NVL(:P_DATE_TO,TRUNC(mh.mov_order_date))
and mh.MOV_ORDER_TYPE='RELATED'
--and mh.VEHICLE_TYPE='Rented'
AND TRUNC(MH.CONFIRMED_DATE)<='31-MAY-2019'
AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--and mh.warehouse_org_code!='SCI'
--and mh.transport_mode IN ('Rental Truck','Rental Barge')
AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE mh.mov_order_no=AIA.INVOICE_NUM)

---------------------------------PENDING AP TRIP INVOICE MTO-------------------------- 
                
SELECT
TMH.MOV_ORDER_NO,
TMH.MOV_ORDER_STATUS,
TMH.FROM_INV warehouse_org_code,
TMH.FINAL_DESTINATION,
TMH.TRANSPORT_MODE,
TMH.VEHICLE_NO,
TMH.GATE_OUT,
TMH.GATE_IN
,TO_CHAR(TMH.MOV_ORDER_DATE) MOV_ORDER_DATE
--,TMH.*
FROM
APPS.XXAKG_TO_MO_HDR TMH 
,APPS.XXAKG_TO_MO_DTL TMD
WHERE 1=1
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
and TMH.MOV_ORDER_TYPE='RELATED'
--and TMH.VEHICLE_TYPE='Rented'
and TMH.ORG_ID=85
--and TMH.GATE_OUT='Y'
and TMH.GATE_IN='Y'
and TMH.AP_FLAG is null
--AND TMH.MOV_ORDER_DATE BETWEEN '01-JAN-2016' and '30-JUN-2018'
and TMH.MOV_ORDER_DATE<='20-JUN-2019' 
and TMH.mov_order_status='CONFIRMED'
--and mh.transport_mode='Company Truck'
--AND TO_CHAR (mh.MOV_ORDER_DATE, 'MON-RR') = 'OCT-17'
--AND TRUNC(TMH.mov_order_date) BETWEEN NVL(:P_DATE_FROM,TRUNC(TMH.mov_order_date)) AND NVL(:P_DATE_TO,TRUNC(TMH.mov_order_date))
--AND TMH.VEHICLE_NO!='SCIL-SCM-0001'
--and TMH.FROM_INV='SCI'
--and TMH.transport_mode IN ('Rental Barge')
--AND TMH.MOV_ORDER_NO='MTO/SCOU/052022'
--AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICES_ALL AIA WHERE TMH.MOV_ORDER_NO=AIA.INVOICE_NUM)

