SELECT papf.EMPLOYEE_NUMBER
,papf.FULL_NAME
,pat.NAME absence_type
, paa.date_start leave_start_date
,paa.date_end leave_end_date
, paa.absence_days
--, paa.abs_information_category
--,paa.abs_information2
--, paa.abs_information3
--,paa.abs_information4
FROM apps.per_absence_attendances paa,
apps.per_absence_attendance_types pat,
apps.per_all_people_f papf
WHERE paa.absence_attendance_type_id = pat.absence_attendance_type_id
AND papf.person_id = paa.person_id
AND TRUNC (paa.date_start) BETWEEN TRUNC(papf.effective_start_date)
AND TRUNC (papf.effective_end_date)
AND papf.EMPLOYEE_NUMBER=nvl(:p_employee_number,papf.EMPLOYEE_NUMBER)
AND TO_CHAR (paa.date_start,'RRRR')='2019'
AND pat.NAME!='Official Tour'
order by papf.EMPLOYEE_NUMBER,paa.date_start

