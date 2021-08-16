----- Move Order Approval Hierarchy Department and Location wise ------------------------


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



---- Move Order Status ---------------


select
    header_id,
    request_number Move_order_number,
    decode(header_status,
        1,'Incomplete',
        2,'Pending Approval',
        3,'Approved',
        4,'Not Approved',
        5,'Closed',
        6,'Cancelled',
        7,'Pre-Approved',
        8,'Partially Approved',
        9,'Cancelled by Source') Move_order_status
from
    inv.mtl_txn_request_headers
where
    request_number='11903219'
    
    
    
*******************************************


select mtr.creation_date,
    header_id,mtr.CREATED_BY,USER_NAME EMPLOYEE_NUMBER,
    request_number Move_order_number,
    decode(header_status,
        1,'Incomplete',
        2,'Pending Approval',
        3,'Approved',
        4,'Not Approved',
        5,'Closed',
        6,'Cancelled',
        7,'Pre-Approved',
        8,'Partially Approved',
        9,'Cancelled by Source') Move_order_status
from
    inv.mtl_txn_request_headers mtr,apps.fnd_user fu
where
    request_number='11881295'
    and fu.USER_ID=mtr.CREATED_BY


          
---- Move Order Approval Workflow status -----          
select *
from
    apps.xxakg_moapproval_status
where
    header_id in (5518080)
--    wf_status like 'A%'
--    and rownum<10               
