select DISTINCT prha.segment1,
           prha.requisition_header_id,
           ppf.full_name,
           prha.authorization_status,
           prha.type_lookup_code,
           ood.organization_name,
           prda.distribution_id,
           msi.inventory_item_id,
           mc.segment1 item_category,
           mc.segment2 item_type,
           msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item,
           prla.item_description,
           prla.line_num,
           prla.unit_meas_lookup_code,
           prla.unit_price,
           prla.quantity,
           prla.need_by_date,
           to_char ( trunc (prla.creation_date), 'DD-MON-YY') creation_date,
           prla.destination_organization_id,
           gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 "Charge A/C",
           ppa.name project,
           pt.task_number,
           prda.expenditure_type,
           prda.expenditure_item_date
from apps.po_requisition_headers_all prha,
         apps.po_requisition_lines_all prla,
         apps.mtl_system_items_vl msi,
         apps.mtl_item_categories mic,
         apps.mtl_categories mc,
         apps.mtl_category_sets mcs,
         apps.org_organization_definitions ood,
         apps.po_req_distributions_all prda,
         apps.fnd_user fu,
         apps.per_people_f ppf,
         apps.gl_code_combinations gcc,
         apps.pa_projects_all ppa,
         apps.pa_tasks pt
where 1=1
           and prha.requisition_header_id=prla.requisition_header_id
           and prda.requisition_line_id=prla.requisition_line_id
           and msi.inventory_item_id(+)=prla.item_id
           and prla.category_id=mic.category_id(+)
           and prla.category_id=mc.category_id(+)
           and mc.structure_id=mcs.structure_id(+)
           and mic.category_set_id=mcs.category_set_id(+)
           and prha.org_id in ('83')
           and prha.segment1 in ('120117749')
--           and ood.organization_name IN ('Shah Cement Industries -Discrete Organization','Shah Cement Industries Limited')
--           and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='COMP.CCPU.0008'
           and prla.destination_organization_id=ood.organization_id
           and prda.code_combination_id=gcc.code_combination_id
           and prha.created_by=fu.user_id
           and fu.user_name=to_char(ppf.employee_number)
           and sysdate between ppf.effective_start_date and ppf.effective_end_date
           and prda.project_id=ppa.project_id(+)
           and prda.task_id=pt.task_id(+)
order by line_num

select *
from apps.po_requisition_headers_all
where segment1='1200000669'

select *
from apps.po_requisition_lines_all prla
where prla.requisition_header_id=790206
--        and DESTINATION_TYPE_CODE not in 'INVENTORY'

select * 
from apps.po_req_distributions_all

select *
from  apps.mtl_system_items_vl msi
where msi.inventory_item_id=27014
