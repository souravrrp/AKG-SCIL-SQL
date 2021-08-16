select distinct organization,department,aed.subdepartment,aed.employee_number,aed.full_name,
designation,
hap.NAME positions,cost_center,payroll_name,to_char(to_date(aed.date_start),'DD-MON-YYYY')JOIN_DATE,
to_char(paf.EFFECTIVE_START_DATE,'DD-MON-YYYY') Effective_From,paf.EFFECTIVE_END_DATE,aed.location_name,aed.person_type,
to_char(to_date(hap.CREATION_DATE,'DD-MON-YYYY'))CREATION_DATE,fu.USER_NAME CREATED_BY
from apps.akg_employee_details aed,apps.HR_ALL_POSITIONS_F hap,apps.PER_ALL_ASSIGNMENTS_F paf,
apps.fnd_user fu
--where ORGANIZATION='Steel Melting Factory'
where person_type<>'Ex-employee'
and paf.position_id=hap.position_id
and aed.person_id=paf.person_id
and hap.CREATED_BY=fu.user_id(+)
--and hap.NAME='CTGPHT.OFFICER PURCHASE.N'
and sysdate between paf.EFFECTIVE_START_DATE and paf.EFFECTIVE_END_DATE
and sysdate between hap.EFFECTIVE_START_DATE and hap.EFFECTIVE_END_DATE
and aed.employee_number in (11309)
and paf.PRIMARY_FLAG='Y'
--and hap.CREATION_DATE like'%16%'
--and hap.NAME in ('DHKGSO.ASSISTANT MANAGER HR & ADMIN.Y')
--'DHKDLO.ASSISTANT GENERAL MANAGER ACCOUNTS.Y',
--'MSGCMF.ASSISTANT GENERAL MANAGER ACCOUNTS & FINANCE.Y',
--'MSGCMF.SENIOR MANAGER MECHANICAL.N',
--'MSGSCP.MANAGER MECHANICAL POWER.Y',
--'DHKGSO.DEPUTY MANAGER SUPPLY CHAIN.N',
--'DHKGSO.DEPUTY MANAGER SUPPLY CHAIN.Y',
--'MSGCMF.MANAGER PRODUCTION SACK.Y'
--)
--and aed.location_name='Dilkhusha Office, Dhaka'
--and aed.department like 'ELECTRICAL%'
order by 
--2,to_char(to_date(hap.CREATION_DATE,'DD-MON-YYYY')),
to_number(aed.employee_number)
