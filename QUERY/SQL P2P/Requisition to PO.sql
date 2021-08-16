select
    req.organization
    ,req.req_num
    ,req.employee_number
    ,req.req_creator
    ,req.line_num
    ,req.item
    ,req.item_description
    ,req.uom
    ,req.unit_price
    ,req.quantity
    ,req.po_num
from
    apps.po_headers_all pha,
(
select DISTINCT prha.segment1 req_num,
           prha.requisition_header_id,
           ppf.employee_number,
           ppf.full_name req_creator,
           prha.authorization_status,
           prha.type_lookup_code,
           ood.organization_name organization,
           prda.distribution_id,
           msi.inventory_item_id,
           msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item,
           prla.item_description,
           prla.line_num,
           prla.unit_meas_lookup_code uom,
           prla.unit_price,
           prla.quantity,
           prla.need_by_date,
           to_char ( trunc (prla.creation_date), 'DD-MON-YY') creation_date,
           prla.destination_organization_id,
           gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 "Charge A/C",
           NVL(APPS.XXAKG_PO_FROM_REQ.AKG_GET_PO_FRM_REQ_DIST( :P_ORG_ID,prha.requisition_header_id,prla.line_num),
                APPS.XXAKG_PO_FROM_REQ.AKG_GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prha.requisition_header_id,prla.line_num)) po_num
from apps.po_requisition_headers_all prha,
         apps.po_requisition_lines_all prla,
         apps.mtl_system_items_vl msi,
         apps.org_organization_definitions ood,
         apps.po_req_distributions_all prda,
         apps.fnd_user fu,
         apps.per_people_f ppf,
         apps.gl_code_combinations gcc
where 1=1
           and prha.requisition_header_id=prla.requisition_header_id
           and prda.requisition_line_id=prla.requisition_line_id
           and msi.inventory_item_id=prla.item_id
--           and prha.authorization_status in ('APPROVED')
--           and prha.created_by in ('8797')
--           and prha.segment1 in ('120129167')
           and prha.org_id in (83)
--           and prla.item_description like '%Air%C%'
--           and ood.organization_name IN ('Shah Cement Industries -Discrete Organization','Shah Cement Industries Limited')
--           and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('CPRN.STAT.2229')
           and prla.destination_organization_id=ood.organization_id
           and prda.code_combination_id=gcc.code_combination_id
           and prha.created_by=fu.user_id
           and fu.user_name=to_char(ppf.employee_number)
           and sysdate between ppf.effective_start_date and ppf.effective_end_date
order by prha.segment1, prla.line_num) req
where 1=1
    and pha.segment1(+)=req.po_num
    and req.req_num in ('120117749')
--    and pha.segment1 in ('FA/SCOU/000802','FA/SCOU/000844','FA/SCOU/000845','FA/SCOU/000842')
order by req_num, line_num