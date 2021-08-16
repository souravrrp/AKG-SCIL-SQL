SELECT 
    A.ORGANIZATION, 
    A.LEGAL_ENTITY, 
    A.DIVISION,
    A.EMPLOYEE_NUMBER,
    A.FULL_NAME,
    A.DEPARTMENT,
    A.SUBDEPARTMENT,
    A.DESIGNATION,
    A.EMPLOYMENT_CATEGORY,
    l.DATE_START,
    l.DATE_END,
    l.C_TYPE_DESC,
    l.CATEGORY_MEANING,
    l.ABSENCE_DAYS
FROM 
    apps.akg_employee_details A,
    apps.xxakg_leave_balance l
WHERE 
    A.PERSON_ID=l.PERSON_ID
 AND A.EMPLOYEE_NUMBER='21641'
 --AND A.ORGANIZATION in ('AKCL','SCIL','SPL')
AND TRUNC (l.DATE_START) BETWEEN '25-APR-2017' AND '26-MAY-2017'
--AND A.DIVISION='Cement Division'