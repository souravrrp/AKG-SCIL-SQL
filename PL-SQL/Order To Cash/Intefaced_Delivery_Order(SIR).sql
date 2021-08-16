SELECT a.request_id,
a.org_id,
b.name,
a.interface_line_id,
a.creation_date,
a.interface_line_context,
apps.xxakg_ar_pkg.get_region_from_cust_id (a.orig_system_bill_customer_id) region,
(select hca.account_number||' - '|| hp.party_name from apps.hz_cust_accounts hca,apps.hz_parties hp where hca.party_id=hp.party_id and hca.cust_account_id=a.orig_system_bill_customer_id) customer_name,
a.sales_order,
(select segment1||'.'||segment2||'.'||segment3 from inv.mtl_system_items_b where organization_id=a.warehouse_id and inventory_item_id=a.inventory_item_id) item_code,
a.description,
a.sales_order_date,
a.sales_order_source,
a.interface_line_attribute2,
a.interface_line_attribute1,
a.interface_line_attribute6,
a.interface_line_attribute11,
a.batch_source_name,
a.set_of_books_id,
a.line_type,
a.quantity,
a.amount,
a.cust_trx_type_id,
a.ship_date_actual,
a.gl_date,
a.trx_date,
a.warehouse_id,
a.inventory_item_id,
a.term_name
from apps.ra_interface_lines_all a,apps.hr_operating_units b 
where 1=1 
and a.org_id=b.organization_id
and org_id=:org_id --85
--and apps.xxakg_ar_pkg.get_customer_number_from_id (a.orig_system_bill_customer_id)= :p_customer_number
and interface_status is null 
and batch_source_name ='ORDER_ENTRY'
order by b.name,a.creation_date
