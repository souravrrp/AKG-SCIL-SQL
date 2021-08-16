select distinct pha.segment1,
        --pha.created_by,
--        ppf.employee_number,
        ppf.full_name PO_creator,
--        pla.line_num,
        pla.purchase_basis,
        plt.line_type,
        pla.item_description,
        pla.UNIT_PRICE,
        pla.QUANTITY,
        pla.UNIT_PRICE*pla.QUANTITY amount,
        pla.attribute2 Brand,
        pla.attribute3 Origin,
        --pla.attribute7,
        ppf2.employee_number,
        ppf2.full_name Vehicle_User,
        pla.attribute8 Vehicle,
        trunc(pla.creation_date) creation_date
from apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.fnd_user fu,
        apps.per_people_f ppf,
        apps.per_people_f ppf2,
        apps.po_line_types plt
where pha.created_by=fu.user_id
        and fu.user_name=ppf.employee_number
        --and ppf.employee_number=29692
        --and pha.authorization_status='APPROVED'
        and pha.po_header_id=pla.po_header_id
        and pla.line_type_id=plt.line_type_id
        --and pla.purchase_basis='SERVICES'
        --and pha.segment1='L/SCOU/023723'  
        and plt.line_type='Service'
        and pla.attribute7=ppf2.person_id
        and pla.attribute8 like '%4557%'
        and sysdate between ppf.effective_start_date and ppf.effective_end_date
        and sysdate between ppf2.effective_start_date and ppf2.effective_end_date
--order by pha.segment1
----             pla.line_num
        