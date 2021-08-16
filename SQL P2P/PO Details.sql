select distinct 
        pha.segment1 "PO Number",
        pha.po_header_id,
        pda.po_distribution_id,
        pha.cancel_flag PO_cancel,
        pla.cancel_flag line_cancel,
        pda.gl_cancelled_date distribution_cancel,
        ood.organization_name,
        pda.destination_type_code,
--        pha.type_lookup_code "PO Type",
        pha.authorization_status,
        TO_CHAR (TRUNC(pha.creation_date), 'DD-MON-RR') CREATION_DATE,
        TO_CHAR (TRUNC(pha.last_update_date), 'DD-MON-RR') LAST_UPDATE_DATE,
        TO_CHAR (TRUNC(pha.approved_date), 'DD-MON-RR') APPROVED_DATE,
        pha.created_by,
        ppf.full_name po_creator,
        pv.segment1 "Supplier ID",
        pv.vendor_name "Supplier Name",
        pvsa.vendor_site_code "Supplier Site",
        pla.line_num,
        pla.purchase_basis "Line Type",
--        pla.item_id,
        mc.segment1 item_category,
        mc.segment2 item_type,
        msi.segment1||'.'||msi.segment2||'.'||msi.segment3 "Item Code",
        pla.item_description,
        pla.unit_meas_lookup_code "UOM",
        pha.currency_code,
        pha.rate,
        pll.quantity,
        pll.quantity_received,
        pll.quantity_accepted,
        pll.quantity_rejected,
        pll.quantity_billed,
        pll.quantity_cancelled,
        pll.quantity_received-pll.quantity_billed quantity_remaining,
        pla.unit_price,
        pla.quantity*pla.unit_price amount,
--        pla.closed_code,
        pla.attribute2 brand,
        pla.attribute3 origin,
        pll.qty_rcv_tolerance,
        ppa.name project,
        pt.task_number,
        pda.expenditure_type,
        pda.expenditure_item_date,
--        pll.match_option,
        decode(pll.match_option,
                    'R', 'Receipt',
                    'P', 'PO') invoice_match_option,
        pll.receipt_required_flag,
        pda.accrue_on_receipt_flag,
        gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 po_charge_account,
        gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5 accrual_account,
        flex.description account_description,
        prha.segment1 requisition_no
--        pda.*
from apps.po_headers_all pha,
     apps.po_lines_all pla,
     apps.po_line_locations_all pll,
     apps.gl_code_combinations gcc,
     apps.gl_code_combinations gcc1,
    apps.po_distributions_all pda,
    apps.ap_suppliers pv,
    apps.ap_supplier_sites_all pvsa,
    apps.mtl_system_items_vl msi,
    apps.org_organization_definitions ood,
    apps.fnd_flex_values_vl flex,
    apps.fnd_user fu,
    apps.per_people_f ppf,
    apps.pa_projects_all ppa,
    apps.pa_tasks pt,
    apps.mtl_item_categories mic,
    apps.mtl_categories mc,
    apps.mtl_category_sets mcs,
    apps.po_req_distributions_all prda,   
    apps.po_requisition_lines_all prla,  
    apps.po_requisition_headers_all prha
where 1=1
    and pha.org_id = 85
    and pha.segment1 like ('L/SCOU/036072')
    and msi.inventory_item_id=mic.inventory_item_id(+)
    and msi.organization_id=mic.organization_id(+)
    and pla.category_id=mic.category_id(+)
    and pla.category_id=mc.category_id(+)
--    and mic.category_id=mc.category_id(+)
    and mc.structure_id=mcs.structure_id(+)
    and mic.category_set_id=mcs.category_set_id(+)
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('BRND.GIFT.0001')
--    and pha.creation_date between '01-JAN-2017' and '16-MAY-2018'
--    and pda.destination_organization_id=1345
--    and pda.destination_type_code = 'EXPENSE'
    and (pha.cancel_flag is null or pha.cancel_flag='N')
    and (pla.cancel_flag is null or pla.cancel_flag='N')
    and pda.gl_cancelled_date is null
--    and gcc.segment2 in ('BRAND','MKT')
--    and gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5 != '2110.NUL.1050102.9999.00'
--    AND mc.segment1='INGREDIENT'
--    and ppf.employee_number in (1601)
    and pla.po_header_id=pha.po_header_id
    and pla.po_header_id=pda.po_header_id
    and pha.po_header_id=pll.po_header_id
    and pla.po_line_id=pda.po_line_id
    and pla.po_line_id=pll.po_line_id
    and gcc.code_combination_id=pda.code_combination_id
    and gcc1.code_combination_id=pda.accrual_account_id
    and gcc.segment3=flex.flex_value_meaning
    and pha.vendor_id=pv.vendor_id
    and msi.inventory_item_id(+)=pla.item_id
    and ood.organization_id=pda.destination_organization_id
    and ood.organization_id=msi.organization_id(+)
    and ood.operating_unit=pha.org_id
    and pvsa.vendor_id=pv.vendor_id
    and pha.vendor_site_id=pvsa.vendor_site_id
    and pha.created_by=fu.user_id
    and fu.user_name=to_char(ppf.employee_number)
    and sysdate between ppf.effective_start_date and ppf.effective_end_date
    and pda.project_id=ppa.project_id(+)
    and pda.task_id=pt.task_id(+)
    and pda.req_distribution_id = prda.distribution_id(+)   
    and prda.requisition_line_id = prla.requisition_line_id(+)
    and prla.requisition_header_id = prha.requisition_header_id(+) 
--    and rownum=10
order by pha.segment1,
            pla.line_num
    

select * from apps.po_headers_all
where segment1 in ('I/SCOU/02096')

select * from apps.po_lines_all
where po_header_id=1024045

select * from apps.po_distributions_all
where po_header_id=1024045

 and po_line_id=1472565
 
 select * from apps.per_people_f
 where person_id=2885
 
 select * from apps.po_line_locations_all
where po_header_id=1024044

select * from apps.mtl_categories
where category_id=647995

select * from apps.pa_projects_all
where 1=1
and name like 'SCIL%Mill%'

select * from apps.xxakg_lc_details