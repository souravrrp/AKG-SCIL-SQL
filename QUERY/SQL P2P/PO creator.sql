--PO Creator
select distinct pha.segment1,
pha.created_by,
fnd.user_name Employee_ID,
ppf.full_name
--pha.last_updated_by,
--fnd.user_name Employee_ID,
--ppf.full_name
from apps.po_headers_all pha,
apps.per_people_f ppf,
apps.fnd_user fnd
where pha.segment1 IN ('L/SCOU/034647')
and pha.created_by=fnd.user_id
--and pha.last_updated_by=fnd.user_id
and fnd.user_name=ppf.employee_number
and sysdate between ppf.effective_start_date and ppf.effective_end_date

--GRN Creator
select distinct rsh.receipt_num,
rsh.created_by,
fnd.user_name Employee_ID,
ppf.full_name,
--rsh.last_updated_by,
--fnd.user_name Employee_ID,
--ppf.full_name,
pv.segment1,
pv.vendor_id,
pv.vendor_name
from apps.rcv_shipment_headers rsh,
apps.per_people_f ppf,
apps.fnd_user fnd,
apps.ap_suppliers pv
where rsh.receipt_num=22331
and rsh.created_by=fnd.user_id
--and rsh.last_updated_by=fnd.user_id
and fnd.user_name=ppf.employee_number
and pv.vendor_id=rsh.vendor_id

--Invoice Creator
select distinct aia.doc_sequence_value voucher_number,
aia.created_by,
aed.employee_number,
aed.full_name,
aed.designation,
aed.department,
aed.subdepartment,
aed.location_name,
aed.email_address,
aed.personal_phone,
aed.company_phone
--aia.last_updated_by,
--fnd.user_name Employee_ID,
--ppf.full_name
from apps.ap_invoices_all aia,
apps.akg_employee_details aed,
apps.fnd_user fnd
where aia.doc_sequence_value in (219032239)
and aia.created_by=fnd.user_id
and aia.set_of_books_id=2025
--and aia.last_updated_by=fnd.user_id
and fnd.user_name=to_char(aed.employee_number)
--and aed.employee_number not in (2087)