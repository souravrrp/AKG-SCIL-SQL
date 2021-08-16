select b.name,
decode(batch_number,null,'Invoice','Receipt') batch_type, 
batch_status,
org_id,
batch_number,
apps.xxakg_com_pkg.get_emp_name_from_user_id (created_by) created_by,
creation_date,
apps.xxakg_com_pkg.get_emp_name_from_user_id (updated_by) updated_by,
update_date,
gl_date,
voucher,
apps.xxakg_ar_pkg.get_customer_name_with_number (customer_id) customer,
receipt_number rcpt_trx_number,
amount
from apps.xxakg_ar_unposted_batch_dtl_v a, apps.hr_operating_units b
where 1=1
and a.org_id=b.organization_id 
and a.org_id = :p_org_id 
and to_char(gl_date,'MON-RR') = :period_name
and batch_status !='Incomplete' 
union all
select hr_operating_units.name hou_name,
'Invoice' batch_type,
'Incomplete' batch_status,
ra_customer_trx_all.org_id,
null,
nvl(apps.xxakg_com_pkg.get_emp_name_from_user_id (ra_customer_trx_all.created_by),ra_customer_trx_all.created_by) created_by,
ra_customer_trx_all.creation_date,
nvl(apps.xxakg_com_pkg.get_emp_name_from_user_id (ra_customer_trx_all.last_updated_by),ra_customer_trx_all.last_updated_by) updated_by,
ra_customer_trx_all.last_update_date,
ra_cust_trx_line_gl_dist_all.gl_date,
ra_customer_trx_all.doc_sequence_value voucher,
apps.xxakg_ar_pkg.get_customer_name_with_number (ra_customer_trx_all.bill_to_customer_id) customer,
ra_customer_trx_all.trx_number
,ra_cust_trx_line_gl_dist_all.acctd_amount amount
from ar.ra_customer_trx_all ,ar.ra_cust_trx_line_gl_dist_all, apps.hr_operating_units
where ra_customer_trx_all.customer_trx_id=ra_cust_trx_line_gl_dist_all.customer_trx_id 
and ra_customer_trx_all.org_id=hr_operating_units.organization_id
and to_char(gl_date,'MON-RR')=:period_name 
and ra_customer_trx_all.org_id = :p_org_id
and ra_cust_trx_line_gl_dist_all.account_class='REC'
and nvl(ra_customer_trx_all.complete_flag,'N')='N'
order by 3,9 
