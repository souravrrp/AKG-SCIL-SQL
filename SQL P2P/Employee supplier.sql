select *
from apps.ap_suppliers aps
where vendor_name='Ismat Jahan'
--and vendor_type_lookup_code not IN 'EMPLOYEE'

select *
from apps.ap_supplier_sites_all


select distinct
--        aps.vendor_id,
        ppf.employee_number,
        aps.segment1 supplier_number,
        aps.vendor_name,
        apss.vendor_site_code,
        hou.name,
        apss.PURCHASING_SITE_FLAG,
        apss.PAY_SITE_FLAG,
        apss.RFQ_ONLY_SITE_FLAG,
--        apss.org_id,
        aps.enabled_flag,
        aps.vendor_type_lookup_code supplier_type,
        aps.start_date_active,
        aps.end_date_active,
        aps.attribute1,
        aps.attribute13 supplier_group,
        aps.party_id
from apps.ap_suppliers aps,
        apps.ap_supplier_sites_all apss,
        apps.hr_operating_units hou,
        apps.per_people_f ppf
where 1=1
        and apss.vendor_id=aps.vendor_id
        and aps.vendor_type_lookup_code='EMPLOYEE'
        and hou.organization_id=apss.org_id
        and aps.employee_id=ppf.person_id
--        and aps.segment1 like (20777)
        and ppf.employee_number in (24833)
        
        
select *
from apps.po_line_locations_all
where shipment_num not in '151'

select *
from apps.po_lines_all