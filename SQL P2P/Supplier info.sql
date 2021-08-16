select distinct
        aps.vendor_id,
        aps.segment1 supplier_no,
        aps.vendor_name,
        aps.vendor_name_alt cheque_name,
        aps.vendor_type_lookup_code supplier_type,
        aps.attribute13 supplier_group, 
        aps.last_updated_by,
        hou.name,
        apss.vendor_site_code,
        apss.address_line1,
        apss.ADDRESS_LINES_ALT,
        apss.ADDRESS_LINE2,
        apss.ADDRESS_LINE3,
        apss.city,
        apss.country,
        apss.PURCHASING_SITE_FLAG,
        apss.RFQ_ONLY_SITE_FLAG,
        apss.PAY_SITE_FLAG,
        apss.ALLOW_AWT_FLAG,
        gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 prepayment_account,
        to_char( trunc( aps.start_date_active), 'DD-MON-YYYY' ) start_date_active,
        to_char( trunc( aps.end_date_active), 'DD-MON-YYYY' ) end_date_active,
        apss.created_by,
        to_char( trunc( apss.creation_date), 'DD-MON-YYYY' ) creation_date,
        apss.last_updated_by,
        to_char( trunc( apss.last_update_date), 'DD-MON-YYYY' ) last_update_date,
        apss.payment_priority,
        apss.create_debit_memo_flag
from apps.ap_suppliers aps,
        apps.ap_supplier_sites_all apss,
        apps.hr_operating_units hou,
        apps.gl_code_combinations gcc
where aps.vendor_id=apss.vendor_id
        and hou.organization_id=apss.org_id
        and apss.prepay_code_combination_id=gcc.code_combination_id
--        and apss.create_debit_memo_flag!='N'
--        and aps.vendor_type_lookup_code='TRANSPORTER'
--        and hou.organization_id=1605
--        and apss.vendor_site_code not in ('AP AR Netting','Z AP AR Netting')
        and aps.segment1 in (22435)
--        and aps.vendor_name like '%Mailam%'
order by 1
        
select * from apps.ap_supplier_sites_all
where VENDOR_ID=1922


select * from apps.ap_suppliers
where segment1=5461

select * from apps.fnd_user
where user_id=1506


select * from apps.akg_employee_details
where employee_number in (628)

select * from apps.ap_invoices_all
where doc_sequence_value=
