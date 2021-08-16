select
dbm.region_name,
--mh.mov_ord_hdr_id,
mh.mov_order_no,
--mh.mov_order_date,
mh.mov_order_status,
--mh.mov_order_type,
mh.final_destination,
--mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
--dh.do_hdr_id,
dh.do_status,
dh.do_number,
--dh.do_date,
dh.customer_number,
dh.customer_name,
--dl.do_number,
--dl.order_number,
--dl.order_header_id,
--dl.order_line_id,
--dl.line_number,
--dl.ordered_item_id,
dl.item_number,
dl.item_description,
dl.line_quantity DO_QUANTITY,
dl.uom_code,
dl.warehouse_org_code,
to_char(mh.confirmed_date) move_confirmed_date
,mh.gate_out
,mh.ready_for_invoice
,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh,apps.xxakg_mov_ord_dtl md,
apps.xxakg_del_ord_hdr dh,apps.xxakg_del_ord_do_lines dl,
apps.xxakg_distributor_block_m dbm
where mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and md.do_hdr_id=dh.do_hdr_id
and dh.do_hdr_id=dl.do_hdr_id
and dh.customer_number=dbm.customer_number(+)
and mh.gate_out='Y'
and mh.gate_in='Y'
and mh.ap_flag is null
and mh.ready_for_invoice='N'
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id and ol.flow_status_code IN ('CLOSED','SHIPPED') and oh.order_type_id=1099 
                                                                                                                                                                         /* and ol.actual_shipment_date>='01-OCT-2017' between '01-OCT-2017' AND '18-NOV-2017'*/)
and mh.org_id=85
and mh.mov_order_status='CONFIRMED'
and mh.transport_mode='Company Truck'
--AND TO_CHAR (mh.confirmed_date, 'MON-RR') = 'OCT-17'
and mh.confirmed_date>='01-OCT-2017' 
--order by mh.confirmed_date desc
UNION ALL
select
dbm.region_name,
--mh.mov_ord_hdr_id,
mh.mov_order_no,
--mh.mov_order_date,
mh.mov_order_status,
--mh.mov_order_type,
mh.final_destination,
--mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
--dh.do_hdr_id,
dh.do_status,
dh.do_number,
--dh.do_date,
dh.customer_number,
dh.customer_name,
--dl.do_number,
--dl.order_number,
--dl.order_header_id,
--dl.order_line_id,
--dl.line_number,
--dl.ordered_item_id,
dl.item_number,
dl.item_description,
dl.line_quantity DO_QUANTITY,
dl.uom_code,
dl.warehouse_org_code,
to_char(mh.confirmed_date) move_confirmed_date
,mh.gate_out
,mh.ready_for_invoice
,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh,apps.xxakg_mov_ord_dtl md,
apps.xxakg_del_ord_hdr dh,apps.xxakg_del_ord_do_lines dl,
apps.xxakg_distributor_block_m dbm
where mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and md.do_hdr_id=dh.do_hdr_id
and dh.do_hdr_id=dl.do_hdr_id
and dh.customer_number=dbm.customer_number(+)
and mh.gate_out='Y'
--and mh.gate_in='Y'
and mh.ap_flag is null
and mh.ready_for_invoice='N'
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id and ol.flow_status_code IN ('CLOSED','SHIPPED') and oh.order_type_id=1099 
                                                                                                                                                                         /* and ol.actual_shipment_date>='01-OCT-2017' between '01-OCT-2017' AND '18-NOV-2017'*/)
and mh.org_id=85
and mh.mov_order_status='CONFIRMED'
and mh.transport_mode='Rental Truck'
--AND TO_CHAR (mh.confirmed_date, 'MON-RR') = 'OCT-17'
and mh.confirmed_date>='01-OCT-2017' 
--order by mh.confirmed_date desc;


------------------------------------------------------------------------------------------------

select 
--md.customer_number,
mh.mov_order_no,
TO_CHAR(mh.mov_order_date) mov_order_date,
mh.mov_order_status,
sum(ool.ordered_quantity) quantity,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
--,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and to_char(ool.actual_shipment_date,'MON-RR')='AUG-18'
--and ool.actual_shipment_date<='31-AUG-2018'
and mh.ready_for_invoice='N'
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Truck'
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
--,mh.ap_flag