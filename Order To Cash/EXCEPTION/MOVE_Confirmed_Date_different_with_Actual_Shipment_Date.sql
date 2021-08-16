select 
md.customer_number,
md.do_number,
--mh.mov_ord_hdr_id,
mh.mov_order_no,
TO_CHAR(mh.confirmed_date) move_confirmed_date,
mh.mov_order_status,
--mh.mov_order_type,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap,
mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and mh.org_id=85
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
AND TO_CHAR (mh.confirmed_date, 'MON-RR') = 'NOV-17'
and exists (select 1 from apps.oe_order_lines_all ool, apps.xxakg_mov_ord_dtl modt 
                where ool.shipment_priority_code=modt.do_number 
                and to_char(ool.actual_shipment_date,'MON-RR')='DEC-17' 
                and mh.mov_ord_hdr_id=modt.mov_ord_hdr_id)