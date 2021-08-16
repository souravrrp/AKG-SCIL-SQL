SELECT cust.customer_number, cust.customer_name, 
sum(decode(msi.concatenated_segments, 'CMNT.SBAG.0001', ctl.quantity_invoiced, null)) quantity_invoiced_sp, 
sum(decode(msi.concatenated_segments, 'CMNT.SBAG.0001', ctl.quantity_invoiced*ctl.UNIT_SELLING_PRICE, null)) value_invoiced_sp, 
sum(decode(msi.concatenated_segments, 'CMNT.PBAG.0001', ctl.quantity_invoiced, null)) quantity_invoiced_pp, 
sum(decode(msi.concatenated_segments, 'CMNT.PBAG.0001', ctl.quantity_invoiced*ctl.UNIT_SELLING_PRICE, null)) value_invoiced_pp, 
--sum(decode(msi.concatenated_segments, 'CMNT.OBAG.0001', ctl.quantity_invoiced, null)) quantity_invoiced_opc, 
--sum(decode(msi.concatenated_segments, 'CMNT.OBAG.0001', ctl.quantity_invoiced*ctl.UNIT_SELLING_PRICE, null)) value_invoiced_opc, 
sum(decode(msi.concatenated_segments, 'CMNT.SBAG.0001', null, 'CMNT.PBAG.0001', null, 'EBAG.OBAG.0001', null, ctl.quantity_invoiced)) quantity_invoiced_bulk ,
sum(decode(msi.concatenated_segments, 'CMNT.SBAG.0001', null, 'CMNT.PBAG.0001', null, 'EBAG.OBAG.0001', null, ctl.quantity_invoiced*ctl.UNIT_SELLING_PRICE)) value_invoiced_bulk 
from  APPS.ra_customer_trx_lines_all ctl,
         APPS.ra_customer_trx_all ct,
         APPS.oe_order_lines_all sol,
         APPS.oe_order_headers_all soh,
         APPS.mtl_system_items_kfv msi,
         APPS.xxakg_ar_customer_site_v cust,
         APPS.xxakg_distributor_block_m r,
         APPS.xxakg_mov_ord_dtl mvd,
         APPS.xxakg_mov_ord_hdr  mvh,
         APPS.xxakg_del_ord_hdr doh          
where ctl.line_type = 'LINE'
and ctl.interface_line_context = 'ORDER ENTRY'
and soh.header_id = sol.header_id
and ctl.interface_line_attribute6 = to_char(sol.line_id)
and ctl.interface_line_attribute1 = to_char(soh.order_number)
and ctl.sales_order = soh.order_number
and msi.inventory_item_id = ctl.inventory_item_id
and msi.organization_id = ctl.warehouse_id 
and ct.customer_trx_id = ctl.customer_trx_id
and ct.bill_to_customer_id = cust.customer_id
and ct.org_id = cust.org_id
and cust.site_use_code = 'BILL_TO'
and cust.primary_flag = 'Y'
--and (:P_CUSTOMER_STATUS is null OR (cust.status = :P_CUSTOMER_STATUS))
and sol.flow_status_code <> 'CANCELLED'
and  msi.concatenated_segments NOT IN ('EBAG.SBAG.0001', 'EBAG.PBAG.0001', 'EBAG.OBAG.0001', 'EBAG.CBAG.0001')
AND  cust.customer_id = r.customer_id (+)
AND  cust.org_id = r.org_id (+)
and   sol.shipment_priority_code = mvd.do_number
and   mvh.mov_ord_hdr_id = mvd.mov_ord_hdr_id
and   doh.do_hdr_id = mvd.do_hdr_id
and   ct.org_id = 85
and   cust.customer_number  =   '188161'
/*and (:p_region_name is null or (r.region_name = :p_region_name))
and (:p_warehouse is null or (ctl.warehouse_id = :p_warehouse))
and (:p_customer_id is null or (cust.customer_id = :p_customer_id))*/
--and trunc(sol.actual_shipment_date) between :p_date_from and :p_date_to
group by --NVL (r.region_name, 'Not Defined'), --ctl.warehouse_id,
cust.customer_number, cust.customer_name 
order by cust.customer_number
