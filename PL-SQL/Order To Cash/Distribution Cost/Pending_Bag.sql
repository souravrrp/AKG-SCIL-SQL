select 
----md.customer_number,
----mh.mov_ord_hdr_id,
--mh.mov_order_no,
--TO_CHAR(mh.mov_order_date) mov_order_date,
--mh.mov_order_status,
----mh.mov_order_type,
--mh.final_destination,
--mh.warehouse_org_code move_wh_org_code,
--mh.transport_mode,
--mh.gate_out,
--mh.gate_in,
--mh.ready_for_invoice,
--mh.hire_rate_ap,
--mh.ap_flag
SUM(SHIPPED_QUANTITY) PENDING_SHIPPED_QUANTITY
--,SUM(INVOICED_QUANTITY) PENDING_INVOICED_QUANTITY
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
,apps.xxakg_del_ord_hdr doh
where 1=1
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and DOH.DO_HDR_ID=md.DO_HDR_ID 
AND ool.shipment_priority_code=doh.do_number 
--and mh.ready_for_invoice='Y'
and mh.org_id=85
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
and mh.ap_flag is null
AND MH.TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
--and mh.gate_in IS NULL--='Y'
--and mh.warehouse_org_code!='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
AND TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'MON-RR')='OCT-19'
--AND TO_CHAR (DOH.DO_DATE, 'MON-RR') = 'OCT-18'