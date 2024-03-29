SELECT
USER_ID,
AED.EMPLOYEE_NUMBER,
AED.FULL_NAME,
AED.DESIGNATION,
AED.ORGANIZATION,
AED.COMPANY_PHONE,
AED.SUB_DIVISION,
AED.DIVISION,
AED.SUBDEPARTMENT
FROM
APPS.FND_USER FU,
APPS.AKG_EMPLOYEE_DETAILS AED
WHERE 1=1
AND AED.PERSON_ID=FU.EMPLOYEE_ID
AND AED.EMPLOYEE_NUMBER=:P_Emp_ID
--AND FU.USER_ID=:P_USER_ID




------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
/*
AED.ORGANIZATION,
AED.EMPLOYEE_NUMBER,
AED.FULL_NAME,
AED.DESIGNATION,
AED.DEPARTMENT,
AED.COMPANY_PHONE
*/
FROM
APPS.AKG_EMPLOYEE_DETAILS AED
WHERE 1=1
--AND PERSON_TYPE!='Ex-employee'
--AND PERSON_STATUS='Active Assignment'
--JOINED BY PERSON_ID, EMPLOYEE_NUMBER, 
--SEARCH BY FULL_NAME, LEGAL_ENTITY, DESIGNATION, ORGANIZATION, JOB_LEVEL, COMPANY_PHONE, SUB_DIVISION, DIVISION, JOB_RANK, COST_CENTER, PERSON_STATUS, EMPLOYEE_CATEGORY,
--FIND OUT DATE_OF_BIRTH, DATE_START, SUBDEPARTMENT, PAYROLL_NAME, LOCATION, PERMANENT_ADDRESS, HOME_PHONE, AGE, TENURE_DAY, CONFIRMATION_DATE, 
--AND EMPLOYEE_NUMBER=:EMP_ID
--AND DEPARTMENT LIKE '%ACCOUNTS%'
--and SUBDEPARTMENT='IT'
--AND AED.ORGANIZATION='SCIL'
--AND LOCATION_NAME='Gulshan Office, Dhaka'
--AND DESIGNATION LIKE '%OFFICER%'
--AND AED.FULL_NAME LIKE '%Sak%'
--AND EMAIL_ADDRESS like '%sourav.it%@abulkhairgroup.com'
--AND COMPANY_PHONE LIKE '01985559051'
--AND ROWNUM<=2


SELECT
*
FROM
APPS.FND_USER
WHERE 1=1
--JOINED BY USER_ID, USER_NAME, 
--SEARCH BY EMPLOYEE_ID
--AND USER_NAME='32053'
AND USER_ID=:P_USER_ID
--AND EMPLOYEE_ID=''
--AND EMAIL_ADDRESS='sourav.it@abulkhairgroup.com'




SELECT
*
FROM
APPS.PER_ALL_PEOPLE_F
WHERE 1=1
AND EMPLOYEE_NUMBER=:P_EMPLOYEE_NUMBER
--JOINED BY EMPLOYEE_NUMBER, PARTY_ID, PERSON_ID
--FIND OUT DATE_OF_BIRTH, FIRST_NAME, LAST_NAME, FULL_NAME, NATIONAL_IDENTIFIER, ATTRIBUTE1(BLOOD_GROUP), ORIGINAL_DATE_OF_HIRE, 
--CONDITIONED BY CURRENT_EMPLOYEE_FLAG
--AND PERSON_TYPE_ID='1118'
--AND PERSON_ID='105458'

SELECT
*
FROM
APPS.PER_PEOPLE_F
WHERE 1=1
AND EMPLOYEE_NUMBER=:P_EMPLOYEE_NUMBER

------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT
*
FROM
APPS.PAY_ELEMENT_TYPES_F
WHERE 1=1
--JOINED BY ELEMENT_TYPE_ID, BUSINESS_ID, 
--FIND OUT ELEMENT_NAME, REPORTING_NAME, DESCRIPTION, 
AND ELEMENT_NAME='Phone Allowance Prepaid'


SELECT
*
FROM
APPS.PER_ALL_ASSIGNMENTS_F
--JOINED BY BUSINESS_GROUP_ID, LOCATON_ID, PERSON_ID, ORGANIZATION_ID, 
--SEARCH BY ASSIGNMENT_NUMBER,
--CONDITIONED BY AASIGNMENT_TYPE,


SELECT
*
FROM
APPS.PAY_ELEMENT_ENTRIES_F
--JOINED BY ASSIGNMENT_ID, ELEMENT_LUNK_ID, ELEMENT_TYPE_ID, 

SELECT
*
FROM
APPS.PAY_ELEMENT_LINKS_F
--JOINED BY ELEMENT_LINK_ID, ELEMENT_TYPE_ID,


SELECT
*
FROM
APPS.HR_OPERATING_UNITS


SELECT
*
FROM
APPS.HR_EMPLOYEES
