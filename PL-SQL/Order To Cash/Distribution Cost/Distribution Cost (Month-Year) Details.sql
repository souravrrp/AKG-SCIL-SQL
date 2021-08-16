------------------------------------------------------------------------------------------------
select 'AP Invoice Done' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
--and mh.ap_flag is not null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
and exists (select 1 from apps.ap_invoices_all aia where aia.invoice_num=mh.mov_order_no)
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom
UNION ALL------------------------------------------------------------------------------------------------
select 'AP Invoice in Interface' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
--AND     (:P_Period_YEAR IS NULL OR (to_char(invoice_date,'RRRR') = :P_Period_YEAR))
--AND     (:P_Period_of_Month IS NULL OR (to_char(invoice_date,'MON-RR') = :P_Period_of_Month))
--and to_char(invoice_date,'RRRR')=:P_Period_YEAR
--and to_char(invoice_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(invoice_date)<=NVL(:P_DATE_UPTO,SYSDATE)
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
AND SUBSTR(OOL.ORDERED_ITEM,0,4)='CMNT'
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom
UNION ALL------------------------------------------------------------------------------------------------
select 'AP Invoice Pending' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is not null 
and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom
UNION ALL------------------------------------------------------------------------------------------------
select 'No Hire Rate' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
and mh.hire_rate_ap is null 
--and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom
UNION ALL------------------------------------------------------------------------------------------------
select 'Hire Rate ZERO' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is null 
and mh.hire_rate_ap='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom
UNION ALL------------------------------------------------------------------------------------------------
select 'Pending Ready For Invoice' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
(case 
when  ool.ordered_item='CMNT.OBAG.0004' then (sum(ool.ordered_quantity)*1000)/50
else decode (order_quantity_uom,'MTN', nvl (sum(ool.ordered_quantity), 0) * 20,nvl (sum(ool.ordered_quantity), 0))
end) "Quantity in BAG",
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
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR') = :P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR') = :P_Period_of_Month))
--and to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR
--and to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='N'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
AND OOL.FLOW_STATUS_CODE IN ('CLOSED','SHIPPED')
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
--AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
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
,order_quantity_uom