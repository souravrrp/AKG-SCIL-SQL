--dl.ORDER_NUMBER,dl.ITEM_NUMBER,dl.ITEM_DESCRIPTION,dl.LINE_QUANTITY DO_Quantity,dl.UOM_CODE,dh.DO_NUMBER,dh.DO_DATE,mh.MOV_ORDER_NO,mh.CONFIRMED_DATE,dl.WAREHOUSE_ORG_CODE
select
mh.mov_ord_hdr_id,
mh.mov_order_no,
mh.mov_order_date,
mh.mov_order_status,
mh.mov_order_type,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
dh.do_hdr_id,
dh.do_status,
dh.do_number,
dh.do_date,
dh.customer_number,
dh.customer_name,
--dl.do_number,
dl.order_number,
dl.order_header_id,
dl.order_line_id,
dl.line_number,
dl.ordered_item_id,
dl.item_number,
dl.item_description,
dl.line_quantity,
dl.uom_code,
dl.warehouse_org_code
from
apps.xxakg_mov_ord_hdr mh,apps.xxakg_mov_ord_dtl md,
apps.xxakg_del_ord_hdr dh,apps.xxakg_del_ord_do_lines dl
where mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and md.do_hdr_id=dh.do_hdr_id
and dh.do_hdr_id=dl.do_hdr_id
and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.header_id=dl.order_header_id and ol.shipment_priority_code=dh.do_number and ol.org_id=dh.org_id and ol.flow_status_code='AWAITING_SHIPPING' and oh.order_type_id=1101)
and mh.org_id=85
and mh.mov_order_status='CONFIRMED'
