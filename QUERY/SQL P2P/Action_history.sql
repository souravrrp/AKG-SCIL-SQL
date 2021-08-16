select * from apps.po_headers_all
where 1=1
        and segment1 in ('L/SCOU/028435')
--        and attribute1='IFA'
--        and org_id=83

select * from apps.po_requisition_headers_all
where 1=1
--        and segment1 in ('120127140')
--        and attribute1='IFA'
        and org_id=85
        and PREPARER_ID=1986

select *
--object_id,
--max(sequence_num)
--action_code,
--action_date,
--employee_id,
--approval_path_id,
--object_revision_num
from apps.po_action_history
where 1=1
and object_id=759804
and object_type_code='REQUISITION'
--and sequence_num=max(sequence_num)
--group by object_id,
--action_code,
--action_date,
--employee_id,
--approval_path_id,
--object_revision_num
order by 4 desc

-----------------------------------PO--------------------------------------------
select distinct
        pha.segment1 po_number,
        pha.po_header_id,
        pha.authorization_status,
        pah.sequence_num,
        TO_CHAR( TRUNC( pah.action_date), 'DD-MON-RR') action_date,
        pah.action_code,
        ppf.employee_number,
        ppf.full_name,
--        aed.person_type,
        pps.name aprroval_path
from 
        apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.po_action_history pah,
        apps.per_people_f ppf,
        apps.per_position_structures pps
where 1=1
        and pha.org_id in (85)
        and pha.authorization_status in ('IN PROCESS')
        and pha.segment1 in ('L/SCOU/036072')
--'L/SCOU/035917',
--'L/SCOU/035040',
--'L/SCOU/035878',
--'L/SCOU/036090',
--'L/SCOU/035883',
--'L/SCOU/035773')
--        and ppf.employee_number in (30246)
--        and pah.action_code is null
--        and pah.action_code in ('APPROVE')
--        and pah.action_date between '30-JAN-2019' and '05-FEB-2019'
--        and pps.name is null
        and pha.po_header_id=pah.object_id(+)
        and pah.employee_id=ppf.person_id
        and sysdate between effective_start_date and effective_end_date
        and pah.approval_path_id=pps.position_structure_id(+)
        and pha.po_header_id=pla.po_header_id
        and pha.org_id=pla.org_id
order by pha.segment1, pah.sequence_num desc


-----------------------------------REQUISITION--------------------------------------------
select distinct
        prha.segment1 req_number,
        prha.requisition_header_id,
--        pla.line_num,
--        msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
--        msi.description,
        prha.authorization_status,
        pah.sequence_num,
        TO_CHAR( TRUNC( pah.action_date), 'DD-MON-RR') action_date,
        pah.action_code,
        ppf.employee_number,
        ppf.full_name,
--        aed.person_type,
        pps.name aprroval_path
from 
        apps.po_requisition_headers_all prha,
        apps.po_requisition_lines_all prla,
        apps.mtl_system_items msi,
        apps.po_action_history pah,
        apps.per_people_f ppf,
        apps.per_position_structures pps,
        apps.org_organization_definitions ood
where 1=1
        and prha.segment1 in ('120130039')
        and prha.org_id=85
--        and prha.authorization_status in ('APPROVED')
--        and prha.preparer_id=1986
--        and ppf.employee_number in (25541)
--        and pah.action_code in ('APPROVE')
--        and pah.action_date between '01-JAN-2019' and '08-JAN-2019'
        and prha.requisition_header_id=pah.object_id(+)
        and pah.employee_id=ppf.person_id
        and sysdate between effective_start_date and effective_end_date
        and pah.approval_path_id=pps.position_structure_id(+)
        and prha.requisition_header_id=prla.requisition_header_id
        and prha.org_id=prla.org_id
        and msi.inventory_item_id=prla.item_id
        and ood.organization_id=msi.organization_id
        and ood.operating_unit=prha.org_id
order by pah.sequence_num desc
--------------------------------------------------------------------------


SELECT * FROM APPS.per_people_f
WHERE EMPLOYEE_NUMBER=32862

select * from apps.mtl_system_items
where inventory_item_id=69719


select * from apps.po_lines_all
where po_header_id=85617