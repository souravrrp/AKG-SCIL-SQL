select 'AP Invoice in Interface' Inoice_Status,
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.gate_in_date) gate_in_date,
mh.mov_order_status,
SUM(DECODE (ool.pricing_quantity_uom, 'MTN', ool.ordered_quantity*20,
                                        'BAG', ool.ordered_quantity)) "Quantity in BAG",
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
--and to_char(invoice_date,'MON-RR')='NOV-18'
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
--and to_char(ool.actual_shipment_date,'MON-RR')='NOV-18'
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='Y'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
and mh.ap_flag is null
AND OOL.FLOW_STATUS_CODE='CLOSED'
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

-----------------------------********------------------------------------------------------
select
*
from
apps.ap_invoices_interface aii
where 1=1


and source='AKG TRIP INVOICE'
and aii.INVOICE_NUM in ('MO/SCOU/1022018',
'MO/SCOU/1074728',
)