select *
from apps.xxakg_quot_approval_status

select *
from apps.MTL_TXN_REQUEST_HEADERS
where organization_id in (805)
and request_number in ('9767103')
--and from_subinventory_code in ('AKC-GEN ST')
--and attribute_category in ('AKCL Vehicle Number')

select * from apps.MTL_TXN_REQUEST_Lines where header_id in ('9767103')
--where transaction_type_id in (32,42)
--and date_required between '01-MAR-2018' and '31-MAR-2018'

where  from_subinventory_code like '%SCS%'

select * from apps.MTL_material_transactions_temp

select * from apps.mtl_transaction_types
where transaction_type_name like 'Miscellaneous%'

select distinct
        mtrh.request_number
--        ,mtrh.created_by
        ,ppf.employee_number
        ,ppf.full_name
--        ,mtrh.description
        ,mtrh.move_order_type
--        ,mtt.transaction_type_name
--        ,mtrh.from_subinventory_code
--        ,mtrh.to_subinventory_code
--        ,mtrh.to_account_id
--        ,mtrh.date_required
        ,mtrh.attribute_category
        ,mtrh.attribute5
        ,mtrh.attribute3
        ,mtrh.attribute4
        ,mtrl.line_number
        ,decode(mtrl.line_status,
        1,'Incomplete',
        2,'Pending Approval',
        3,'Approved',
        4,'Not Approved',
        5,'Closed',
        6,'Cancelled',
        7,'Pre-Approved',
        8,'Partially Approved',
        9,'Cancelled by Source') Move_order_status
--        ,mtrl.line_cancel
        ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
        ,msi.description
        ,mtrl.from_subinventory_code
        ,mtrl.to_subinventory_code
--        ,mtrl.to_account_id
--        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
        ,mtrl.UOM_code
        ,mtrl.quantity
        ,mtrl.quantity_delivered
        ,mtrl.quantity_detailed
        ,mtrl.date_required
        ,pha.segment1 po_number
        ,mtrl.transaction_header_id
        ,ppa.name project
        ,pt.task_number
from 
        apps.mtl_txn_request_headers mtrh
        ,apps.mtl_txn_request_lines mtrl
        ,apps.mtl_transaction_types mtt
        ,apps.mtl_system_items msi
        ,apps.gl_code_combinations gcc
        ,apps.fnd_user fu
        ,apps.per_people_f ppf
        ,apps.po_headers_all pha
        ,apps.po_lines_all pla
        ,apps.pa_projects_all ppa
        ,apps.pa_tasks pt
where 1=1
        and mtrh.header_id=mtrl.header_id
        and mtrh.organization_id=mtrl.organization_id
        and mtrh.transaction_type_id=mtt.transaction_type_id(+)
        and mtrl.inventory_item_id=msi.inventory_item_id
        and mtrl.organization_id=msi.organization_id
        and mtrl.to_account_id=gcc.code_combination_id(+)
        and mtrl.project_id=ppa.project_id(+)
        and mtrl.task_id=pt.task_id(+)
        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('BRND.GIFT.0048')
--        and mtrl.line_status in ('3')
        AND mtrl.attribute_category(+) = 'SCIL Brand Expenses'
        AND TO_CHAR (pla.po_line_id) = mtrl.attribute2(+)
        AND pha.po_header_id(+) = pla.po_header_id
--        AND mtrh.organization_id in (805)
--        AND mtrl.from_subinventory_code in ('AKC-GEN ST')
--        and ppf.employee_number in ('2174')
--        and mtt.transaction_type_id in (32,42)
--        and nvl(mtrl.quantity_delivered,0) =0
        AND mtrh.organization_id in (1345)
--        and mtrh.request_number in ('15193926')
--        and ppf.employee_number = '26667'
        and mtrh.created_by = fu.user_id
        and fu.user_name = to_char(ppf.employee_number)
        and sysdate between ppf.effective_start_date and ppf.effective_end_date
order by mtrl.line_number, mtrl.date_required desc

select *
from
    apps.xxakg_moapproval_status
where
    header_id in (11036739)
