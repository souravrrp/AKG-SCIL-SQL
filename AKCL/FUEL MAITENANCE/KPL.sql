select 
    pvrf.registration_number VEHICLE_NO,
    nvl(pvrf.fiscal_ratings,0) KPL_LOCAL,
    nvl(vre_attribute20,pvrf.fiscal_ratings) KPL_DISTRICT
     FROM 
      apps.pqp_vehicle_repository_f pvrf,
      apps.per_all_people_f papf
     where 1=1
--         registration_number like 'DM%SHA%11-0973'
         and  papf.person_id(+)=pvrf.vre_attribute19 
         AND pvrf.VEHICLE_STATUS='A'
        AND pvrf.VRE_ATTRIBUTE3='Road Transport'
         and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(papf.effective_start_date,SYSDATE)) AND TRUNC(NVL(papf.effective_end_date,(SYSDATE+1)))
         and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(pvrf.effective_start_date,SYSDATE)) AND TRUNC(NVL(pvrf.effective_end_date,(SYSDATE+1)));
        