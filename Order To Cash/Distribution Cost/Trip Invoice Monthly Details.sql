------------------------------------------------------------------------------------------------
select 'AP Invoice Done' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
--and mh.ap_flag is not null
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
and exists (select 1 from apps.ap_invoices_all aia where aia.invoice_num=mh.mov_order_no)
group by
--md.customer_number,
mh.mov_order_no,
mh.gate_in_date,
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
UNION ALL------------------------------------------------------------------------------------------------
select 'AP Invoice in Interface' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
apps.ap_invoices_interface aii,
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
where 1=1
and aii.invoice_num=mh.mov_order_no
and source='AKG TRIP INVOICE'
and to_char(invoice_date,'MON-RR')=:P_Period_of_Month
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
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
mh.gate_in_date,
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
UNION ALL------------------------------------------------------------------------------------------------
select 'AP Invoice Pending' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is not null 
and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
and not exists (select 1 from apps.ap_invoices_interface aii where aii.invoice_num=mh.mov_order_no)
group by
--md.customer_number,
mh.mov_order_no,
mh.gate_in_date,
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
UNION ALL------------------------------------------------------------------------------------------------
select 'No Hire Rate' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is null 
--and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
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
mh.gate_in_date,
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
UNION ALL------------------------------------------------------------------------------------------------
select 'Hire Rate ZERO' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is null 
and mh.hire_rate_ap='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
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
mh.gate_in_date,
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
UNION ALL------------------------------------------------------------------------------------------------
select 'Pending Ready For Invoice' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
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
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='N'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
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
mh.gate_in_date,
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
UNION ALL---------------------------------------------------------------------------------------TO_MTO---------
select 'MTO AP Invoice Done' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(CASE 
          WHEN  tdl.item_number='CMNT.OBAG.0004' THEN (SUM(tdl.quantity)*1000)/50
            ELSE SUM(DECODE (tdl.uom_code, 'MTN', tdl.quantity*20,'BAG', tdl.quantity))
END) "Quantity in BAG",
sum(tdl.quantity) quantity,
mh.final_destination,
mh.from_inv move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
'Y' ready_for_invoice
,mh.hire_rate_ap
,mh.ap_flag
from
xxakg.xxakg_to_mo_hdr mh
,apps.xxakg_to_mo_dtl md
,xxakg.xxakg_to_do_lines tdl
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and tdl.to_hdr_id=md.to_hdr_id
and tdl.uom_code IN ('BAG','MTN')
AND SUBSTR(tdl.ITEM_NUMBER,0,4)='CMNT'
--and ool.actual_shipment_date<='31-AUG-2018'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
--and mh.ap_flag is not null
and exists (select 1 from apps.xxakg_to_do_hdr tdh where tdh.to_hdr_id=md.to_hdr_id and tdh.to_status='CONFIRMED' and to_char(tdh.to_date,'MON-RR')=:P_Period_of_Month)--'MAR-19')--
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.from_inv='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
and exists (select 1 from apps.ap_invoices_all aia where aia.invoice_num=mh.mov_order_no)
group by
--md.customer_number,
mh.mov_order_no,
mh.gate_in_date,
mh.mov_order_status,
mh.final_destination,
mh.from_inv,
mh.transport_mode,
mh.gate_out,
mh.gate_in
,mh.hire_rate_ap
,mh.ap_flag
,tdl.item_number
UNION ALL---------------------------------------------------------------------------------------TO_MTO_not_Invoice---------
select 'MTO AP Invoice Pending' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(CASE 
          WHEN  tdl.item_number='CMNT.OBAG.0004' THEN (SUM(tdl.quantity)*1000)/50
            ELSE SUM(DECODE (tdl.uom_code, 'MTN', tdl.quantity*20,'BAG', tdl.quantity))
END) "Quantity in BAG",
sum(tdl.quantity) quantity,
mh.final_destination,
mh.from_inv move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
DECODE (mh.ap_flag, 'Y', 'Y',NULL, 'N') ready_for_invoice
,mh.hire_rate_ap
,mh.ap_flag
from
xxakg.xxakg_to_mo_hdr mh
,apps.xxakg_to_mo_dtl md
,xxakg.xxakg_to_do_lines tdl
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and tdl.to_hdr_id=md.to_hdr_id
and tdl.uom_code IN ('BAG','MTN')
AND SUBSTR(tdl.ITEM_NUMBER,0,4)='CMNT'
--and ool.actual_shipment_date<='31-AUG-2018'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
--and mh.ap_flag is not null
and exists (select 1 from apps.xxakg_to_do_hdr tdh where tdh.to_hdr_id=md.to_hdr_id and tdh.to_status='CONFIRMED' and to_char(tdh.to_date,'MON-RR')=:P_Period_of_Month)--'MAR-19')--
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.from_inv='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
and not exists (select 1 from apps.ap_invoices_all aia where aia.invoice_num=mh.mov_order_no)
group by
--md.customer_number,
mh.mov_order_no,
mh.gate_in_date,
mh.mov_order_status,
mh.final_destination,
mh.from_inv,
mh.transport_mode,
mh.gate_out,
mh.gate_in
,mh.hire_rate_ap
,mh.ap_flag
,tdl.item_number
UNION ALL---------------------------------------------------------------------------------------TO_MTO_Interface---------
select 'MTO AP Invoice in Interface' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(CASE 
          WHEN  tdl.item_number='CMNT.OBAG.0004' THEN (SUM(tdl.quantity)*1000)/50
            ELSE SUM(DECODE (tdl.uom_code, 'MTN', tdl.quantity*20,'BAG', tdl.quantity))
END) "Quantity in BAG",
sum(tdl.quantity) quantity,
mh.final_destination,
mh.from_inv move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
DECODE (mh.ap_flag, 'Y', 'Y',NULL, 'N') ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
from
apps.ap_invoices_interface aii
,xxakg.xxakg_to_mo_hdr mh
,apps.xxakg_to_mo_dtl md
,xxakg.xxakg_to_do_lines tdl
where 1=1
--AND mh.VEHICLE_TYPE='Owned By Company'
and aii.invoice_num=mh.mov_order_no
and source='AKG TRIP INVOICE TO'
--and to_char(invoice_date,'MON-RR')='MAR-19'--:P_Period_of_Month
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and tdl.to_hdr_id=md.to_hdr_id
and tdl.uom_code IN ('BAG','MTN')
AND SUBSTR(tdl.ITEM_NUMBER,0,4)='CMNT'
and exists (select 1 from apps.xxakg_to_do_hdr tdh where tdh.to_hdr_id=md.to_hdr_id and tdh.to_status='CONFIRMED'and to_char(tdh.to_date,'MON-RR')=:P_Period_of_Month)--'MAR-19')--)
--and mh.ap_flag is null
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.from_inv='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
group by
--md.customer_number,
mh.mov_order_no,
mh.gate_in_date,
mh.mov_order_status,
mh.final_destination,
mh.from_inv,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
--mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
,tdl.item_number