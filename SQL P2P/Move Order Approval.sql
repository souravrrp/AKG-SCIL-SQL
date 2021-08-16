select *
from
    apps.xxakg_moapproval_status
where
    header_id in (14640980)
--    wf_status like 'A%'
--    and rownum<10               


select
    fv.flex_value,
    fv.FLEX_VALUE_MEANING,
    fv.DESCRIPTION,
    fv.attribute43 Department,    
    fv.attribute44 raiser_limit,
    fv.attribute45 dept_head_limit,
    (SELECT full_name || '(' || employee_number || ')' emp_name
   FROM apps.per_all_people_f
   WHERE TRUNC(SYSDATE) BETWEEN TRUNC(effective_start_date) AND TRUNC(effective_end_date)
        and person_id=to_number(fv.attribute46)) dept_head,
    (SELECT full_name || '(' || employee_number || ')' emp_name
   FROM apps.per_all_people_f
   WHERE TRUNC(SYSDATE) BETWEEN TRUNC(effective_start_date) AND TRUNC(effective_end_date)
        and person_id=to_number(fv.attribute47)) plant_head,
    hou.name,
    hl.location_code
from
    apps.FND_FLEX_VALUE_SETS fvs, 
    apps.FND_FLEX_VALUES_VL fv,
    apps.hr_locations hl,
--    apps.org_organization_definitions ood
    apps.hr_operating_units hou
where
    fvs.flex_value_set_name like 'XXAKG_MO_APPROVAL_VS'
    and fvs.flex_value_set_id=fv.flex_value_set_id
    and fv.enabled_flag='Y'
    and fv.summary_flag='N'
    and to_number(fv.attribute49)=hl.location_id
    and to_number(fv.attribute48)=hou.organization_id
    and hou.organization_id in (82,85,189)
    and fv.attribute43 in (select 
    department
from
    apps.akg_employee_details
where
    employee_number=:employee_number)
    and hl.location_code in (select 
    location_name
from
    apps.akg_employee_details
where
    employee_number=:employee_number)
order by flex_value
