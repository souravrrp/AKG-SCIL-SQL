SELECT papf.EMPLOYEE_NUMBER
,papf.FULL_NAME
,pat.NAME absence_type
, paa.date_start leave_start_date
,paa.date_end leave_end_date
, paa.absence_days
, dbms_lob.substr(paa.comments,dbms_lob.getlength(paa.comments),1) comments
FROM apps.per_absence_attendances paa,
apps.per_absence_attendance_types pat,
apps.per_all_people_f papf
WHERE paa.absence_attendance_type_id = pat.absence_attendance_type_id
AND papf.person_id = paa.person_id
AND TRUNC (paa.date_start) BETWEEN TRUNC(papf.effective_start_date)
AND TRUNC (papf.effective_end_date)
AND papf.EMPLOYEE_NUMBER=nvl(:p_employee_number,papf.EMPLOYEE_NUMBER)
order by papf.EMPLOYEE_NUMBER,paa.date_start