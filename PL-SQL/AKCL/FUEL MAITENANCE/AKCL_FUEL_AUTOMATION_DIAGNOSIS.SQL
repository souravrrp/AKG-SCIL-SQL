----- KPL, DRIVER------------------
select 
    distinct pvrf.vehicle_repository_id,
    pvrf.registration_number,
    nvl(pvrf.fiscal_ratings,0),
    nvl(vre_attribute20,pvrf.fiscal_ratings),
    papf.employee_number,
    papf.full_name
--   into
--    v_repository,
--    v_registration,
--    v_fiscal_initial,--v_fiscal,
--    v_district_kpl_initial, --v_district_kpl,
--    v_emp_id,
--    v_emp_name
	 FROM 
	  apps.pqp_vehicle_repository_f pvrf,
	  apps.per_all_people_f papf
 	where 
 		registration_number like 'D.M.SHA-11-2324'
 		and  papf.person_id(+)=pvrf.vre_attribute19 
 		and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(papf.effective_start_date,SYSDATE)) AND TRUNC(NVL(papf.effective_end_date,(SYSDATE+1)))
 		and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(pvrf.effective_start_date,SYSDATE)) AND TRUNC(NVL(pvrf.effective_end_date,(SYSDATE+1)));
 		

----------- Distance ----------------- 		
select transport_mode,
   nvl(distance,0)
--   into
--   v_distance
  from
  apps.xxakg_transport_hirerate
  	where org_id=85
  	and from_location=101
  	and transport_mode in ('Company Truck','Company Bulk Carrier')
  	and to_location like 'Pabna%'
  	and end_date_active  is null; 		
  	
  	


--------- Risk and VTS Percentage---------  	
select
    distinct initcap(qr.character1) final_destination,
    qr.character2 destination_type,
    nvl(to_number(qr.character3),0) ,
    nvl(to_number(qr.character4),0) 
-- into
--    v_final_destination,
--    v_destination_type,
--    v_risk,
--    v_vts_percentage
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='FINAL DESTINATION RISK PERCENT'
    and qp.plan_id=qr.plan_id
    and qr.character1 like '%Pabna%'
  	
    ---------------------------------------------------------
    
    
    select
*
from
apps.Q_FINAL_DESTINATION_RISK_PER_V

select
*
from
apps.xxakg_fuel_maintanance
where 1=1
and move_order_no='MO/SCOU/1077271'