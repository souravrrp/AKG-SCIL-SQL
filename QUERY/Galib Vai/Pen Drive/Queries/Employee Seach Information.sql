select * from apps.akg_employee_details
where payroll_name='Ready Mix Payroll'
and person_type<>'Ex-employee'
and SUPERVISOR_ID is not null


select * from apps.akg_employee_details
--where EMAIL_ADDRESS = 'ceo@shahcement.com'
where EMPLOYEE_NUMBER = '3149'
--where FULL_NAME = 'hafiz sikander'
--where payroll_name='shah cement Payroll'
--and person_type<>'Ex-employee'
--and SUPERVISOR_ID is not null