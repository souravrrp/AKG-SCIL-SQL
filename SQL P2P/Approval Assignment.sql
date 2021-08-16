select DISTINCT
hou.name operating_unit,
ppv.name position,
pcf.control_function_name,
pcg.control_group_name,
ppc.start_date,
ppc.end_date,
job_name,
ppv.date_effective,
ppv.date_end,
aed.employee_number,
aed.full_name
from apps.po_position_controls_all ppc,
apps.per_positions_v ppv ,
apps.po_control_groups_all pcg ,
apps.po_control_functions pcf,
apps.hr_operating_units hou,
apps.akg_employee_details aed,
apps.hr_all_positions_f hap,
apps.per_all_assignments_f paf
where 1=1
and ppc.position_id = ppv.position_id
and pcg.control_group_id = ppc.control_group_id
and ppc.control_function_id = pcf.control_function_id
and pcg.org_id=hou.organization_id
--and ppv.name like 'MSGCMF.SENIOR MANAGER ACCOUNTS AND FINANCE.Y'
--AND pcg.control_group_name='UNLIMITED'
and aed.employee_number in (30246)
and paf.position_id(+)=hap.position_id
and hap.position_id = ppv.position_id
and aed.person_id(+)=paf.person_id
and sysdate between paf.EFFECTIVE_START_DATE and paf.EFFECTIVE_END_DATE
and sysdate between hap.EFFECTIVE_START_DATE and hap.EFFECTIVE_END_DATE
order by ppv.name

select * from apps.po_control_groups_all

select * from apps.hr_operating_units