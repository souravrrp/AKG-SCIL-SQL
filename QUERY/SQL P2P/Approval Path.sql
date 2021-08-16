select *
from apps.per_positions

select *
from apps.akg_employee_details
where 1=1
and full_name like '%Afcher%'
--and company in ('SCIL')
--and department in ('HR & ADMIN')
--and subdepartment in ('HR & ADMIN')
--and location_name in ('Gulshan Office, Dhaka')

select 
--        peha.position_structure_id,
--        peha.employee_id,
--        fndu.user_id,
--        ppos.position_id,
        pps.last_update_date,
        pps.name "Approval Path",
        fndu.user_name "Employee Number",
        papf.full_name person,
        ppos.name Position,
        peha.superior_level,
        fndu2.user_name "Employee Number",        
        papf2.full_name "Superior Person",
        ppos2.name SuperiorPosition
--        peha.superior_id SuperiorPersonID,
--        fndu2.user_id SuperiorUserID,
--        ppos2.position_id SuperiorPosID
from apps.po_employee_hierarchies_all peha,
        apps.per_positions ppos,
        apps.per_positions ppos2,
        apps.per_all_people_f papf,
        apps.per_all_people_f papf2,
        apps.fnd_user fndu,
        apps.fnd_user fndu2,
        apps.per_position_structures pps
where pps.business_group_id=peha.business_group_id
        and pps.position_structure_id=peha.position_structure_id
        and fndu2.employee_id=papf2.person_id
        and papf2.person_id=peha.superior_id
        and papf2.effective_end_date>sysdate
        and papf.person_id=peha.employee_id
        and papf.effective_end_date>sysdate
        and ppos2.position_id=peha.superior_position_id
        and ppos.position_id=peha.employee_position_id 
        and peha.superior_level>0
        and peha.employee_id=fndu.employee_id
        and pps.name like 'PSU Electrical Approval'
--        and  
--                (
--                papf2.employee_number=1667
--                ppos.name in ('DHKGSO.SENIOR MANAGER ACCOUNTS.N')
--                or 
--                papf.employee_number=1667
--                ppos2.name in ('DHKGSO.SENIOR MANAGER ACCOUNTS.N')
--                )
order by peha.position_structure_id,
        peha.superior_level,
        papf2.full_name
        