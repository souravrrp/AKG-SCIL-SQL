SELECT 
--        QUA.ROWID ROW_ID,
--          QUA.QUALIFICATION_ID,
--          QUA.BUSINESS_GROUP_ID,
--          QUA.OBJECT_VERSION_NUMBER,
          distinct pou.name "ORGANIZATION",
          PPG.SEGMENT1 EMP_GROUP,
          pjd.SEGMENT1 Department,
          pjd.SEGMENT2 Subdepartment,
    DECODE (QUA.PERSON_ID, NULL, ESA.PERSON_ID, QUA.PERSON_ID)
             PERSON_ID,
             ppf.employee_number,
             ppf.full_name,
             pjd.SEGMENT3 Job_Level,
     DECODE (paf.employment_category,
                    'BN', 'Bangladesh Domicile',
                    'TRN', 'Trainee',
                    'ONB', 'On Board',
                    'Exp', 'Exparties',
                    ' ')
               EMPLOYMENT_CATEGORY,
               past.USER_STATUS EMP_STATUS,
               pcak.segment2 COST_CENTER,
                to_char(to_date(ampv.date_start,'DD-MON-YYYY'))Join_Date,
                to_char(to_date(CONFIRMATION.Confirmation_date,'DD_MON-YYYY'))Confirmation_date,
    decode (paf.EMPLOYEE_CATEGORY,'MGT','MANAGEMENT',
                                                           'NON MANAGEMENT')Employeement_Type,
    decode (COUNTRY_OF_BIRTH,'BD','Bangladesh',
                                                   'IN','INDIA',
                                                   'CN','China',
                                                   'Expatriates')COUNTRY_OF_BIRTH,
     decode(NATIONALITY,'PQH_BD','Bangladeshi',
            'PQH_IN','Indian',
            'PQH_CN','Chinese',
            'UNSPECIFIED')NATIONALITY,
            to_char(to_date(ppf.DATE_OF_BIRTH,'DD-MON-YYYY'))DATE_OF_BIRTH,
            ppf.ATTRIBUTE1 BLOOD_GROUP,ppf.ATTRIBUTE2 RELIGION,
  decode (ppf.SEX,'M','Male',
                    'F','Female',
                    'Unspecified')Gender,
   APPS.XXAKG_ORACLE_PKG.GET_CONTACT_NUMBER (ppf.person_id, 'M')PERSONAL_NUMBER, --GETTING PERSONAL CONTACT NUMBER BY FUNCTION
   APPS.XXAKG_ORACLE_PKG.GET_CONTACT_NUMBER (ppf.person_id, 'C1')OFFICE_NUMBER, --GETTING OFFICE CONTACT NUMBER BY FUNCTION
   APPS.XXAKG_ORACLE_PKG.GET_CONTACT_NUMBER (ppf.person_id, 'H1')HOME_NUMBER , --GETTING HOME CONTACT NUMBER BY FUNCTION
   ppf.EMAIL_ADDRESS,
   decode (ppf.MARITAL_STATUS,'S','Single',
                                        'M','Married',
                                        'Unspecified')Marital_Status,
           PERMANENT_DISTRICT,PRESENT_DISTRICT,
           ADDRESS.PERMANENT_ADDRESS,ADDRESS.PRESENT_ADDRESS,
            APPS.XXAKG_ORACLE_PKG.GET_DATE_DIFF_ALL (CURRENT_DATE,
                                                     ppf.date_of_birth)
               AGE,       ----GETTING AGE INCLUDING DAY MONTH YEAR BY FUNCTION
            APPS.XXAKG_ORACLE_PKG.GET_DATE_YEAR_CAL_YEAR (CURRENT_DATE,
                                                          ppf.date_of_birth)
               AGE_YEAR,
        APPS.XXAKG_ORACLE_PKG.GET_TOTAL_EXPERIENCE (ppf.person_id)
               EXPERIENCE_OTHER_ORGN,
        APPS.XXAKG_ORACLE_PKG.GET_PREVIOUS_JOB_DETAILS (ppf.person_id)
               PREVIOUS_JOB_DETAILS,
          APPS.XXAKG_ORACLE_PKG.GET_DATE_YEAR_CAL_YEAR (CURRENT_DATE,
                                                          ampv.date_start)
               TENURE_YEAR,
            APPS.XXAKG_ORACLE_PKG.GET_DATE_DIFF_ALL (CURRENT_DATE,
                                                     ampv.date_start)
               TENURE,
               ppt.USER_PERSON_TYPE,
               hrl.LOCATION_CODE,
               papf.PAYROLL_NAME,
       APPS.XXAKG_ORACLE_PKG.GET_SUPERVISOR_NAME (paf.person_id)
               SUPERVISOR_NAME,
           QT.TITLE,
          QT.GRADE_ATTAINED,
          QUA.STATUS,
          to_char(to_date (QUA.AWARDED_DATE),'DD-MON-YYYY')AWARDED_DATE,
          QUA.TRAINING_COMPLETED_AMOUNT,
          QT.REIMBURSEMENT_ARRANGEMENTS,
          QT.TRAINING_COMPLETED_UNITS,
          QUA.TOTAL_TRAINING_AMOUNT,
          QUA.START_DATE,
          QUA.END_DATE,
          QUA.LICENSE_NUMBER,
          QUA.EXPIRY_DATE,
          QT.LICENSE_RESTRICTIONS,
          QUA.PROJECTED_COMPLETION_DATE,
          QT.GROUP_RANKING,
          QUA.COMMENTS,
          QUA.QUALIFICATION_TYPE_ID,
          QTT.NAME,
          QUA.ATTENDANCE_ID,
          NVL (ESA.ESTABLISHMENT, EST.NAME) ESTABLISHMENT,
          EST.LOCATION,
          QUA.PROFESSIONAL_BODY_NAME,
          QUA.MEMBERSHIP_NUMBER,
          QT.MEMBERSHIP_CATEGORY,
          QUA.SUBSCRIPTION_PAYMENT_METHOD,
          QUA.ATTRIBUTE_CATEGORY,
          QUA.ATTRIBUTE1,
          QUA.ATTRIBUTE2,
          QUA.ATTRIBUTE3,
          QUA.ATTRIBUTE4,
          QUA.ATTRIBUTE5,
          QUA.ATTRIBUTE6,
          QUA.ATTRIBUTE7,
          QUA.ATTRIBUTE8,
          QUA.ATTRIBUTE9,
          QUA.ATTRIBUTE10,
          QUA.ATTRIBUTE11,
          QUA.ATTRIBUTE12,
          QUA.ATTRIBUTE13,
          QUA.ATTRIBUTE14,
          QUA.ATTRIBUTE15,
          QUA.ATTRIBUTE16,
          QUA.ATTRIBUTE17,
          QUA.ATTRIBUTE18,
          QUA.ATTRIBUTE19,
          QUA.ATTRIBUTE20,
          QUA.QUA_INFORMATION_CATEGORY,
          QUA.QUA_INFORMATION1,
          QUA.QUA_INFORMATION2,
          QUA.QUA_INFORMATION3,
          QUA.QUA_INFORMATION4,
          QUA.QUA_INFORMATION5,
          QUA.QUA_INFORMATION6,
          QUA.QUA_INFORMATION7,
          QUA.QUA_INFORMATION8,
          QUA.QUA_INFORMATION9,
          QUA.QUA_INFORMATION10,
          QUA.QUA_INFORMATION11,
          QUA.QUA_INFORMATION12,
          QUA.QUA_INFORMATION13,
          QUA.QUA_INFORMATION14,
          QUA.QUA_INFORMATION15,
          QUA.QUA_INFORMATION16,
          QUA.QUA_INFORMATION17,
          QUA.QUA_INFORMATION18,
          QUA.QUA_INFORMATION19,
          QUA.QUA_INFORMATION20,
          QUA.LAST_UPDATE_DATE,
          QUA.LAST_UPDATED_BY,
          QUA.LAST_UPDATE_LOGIN,
          QUA.CREATED_BY,
          QUA.CREATION_DATE
     FROM apps.PER_QUALIFICATIONS QUA,
          apps.PER_QUALIFICATIONS_TL QT,
          apps.PER_QUALIFICATION_TYPES_TL QTT,
          apps.PER_ESTABLISHMENT_ATTENDANCES ESA,
          apps.PER_ESTABLISHMENTS EST,
          apps.PER_QUALIFICATION_TYPES QUT,
          apps.per_all_people_f ppf,
          apps.per_all_assignments_f paf,
          apps.per_job_definitions pjd,
          apps.per_jobs pj,
          apps.pay_people_groups ppg,
           apps.per_organization_units pou,
           apps.per_assignment_status_types_tl past,
           apps.pay_cost_allocations_f pcaf,
  apps.pay_cost_allocation_keyflex pcak,
  apps.akg_max_ppos_view ampv,
  apps.PER_PERSON_TYPE_USAGES_F pptu,
  apps.per_person_types ppt,
  apps.hr_locations_all hrl,
  apps.pay_payrolls_f papf,
     (  SELECT PAPF.person_id,
                      papf.employee_number,
                      PPT.USER_PERSON_TYPE,
                      PPTU.EFFECTIVE_START_DATE Confirmation_date
                 FROM apps.per_all_people_f papf,
                      apps.per_person_type_usages_f pptu,
                      apps.per_person_types ppt
                WHERE papf.person_id = pptu.person_id
                      AND pptu.person_type_id = ppt.person_type_id
                      AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
                                              AND  papf.effective_end_date
                      AND TRUNC (SYSDATE) BETWEEN pptu.effective_start_date
                                              AND  pptu.effective_end_date
                      AND ppt.user_person_type = 'Confirmed'
             ORDER BY 1) CONFIRMATION,
                         (  SELECT person_id,
                      MAX(DECODE (
                             address_type,
                             'IN_P',
                                address_line1
                             || ' '
                             || address_line2
                             || ' '
                             || address_line3,
                             ' '))
                         PERMANENT_ADDRESS,
                      MAX(DECODE (
                             address_type,
                             'PHCA',
                                address_line1
                             || ' '
                             || address_line2
                             || ' '
                             || address_line3,
                             ' '))
                         PRESENT_ADDRESS,
                      MAX (DECODE (address_type, 'IN_P', TOWN_OR_CITY))
                         PERMANENT_DISTRICT,
                      MAX(DECODE (address_type,
                                  'PHCA', TOWN_OR_CITY,
                                  DECODE (ADDRESS_TYPE, 'TMPMAIL', TOWN_OR_CITY)))
                         PRESENT_DISTRICT
                 FROM apps.per_addresses
             GROUP BY person_id) ADDRESS
    WHERE     QUA.QUALIFICATION_TYPE_ID = QTT.QUALIFICATION_TYPE_ID
          AND QTT.LANGUAGE = USERENV ('LANG')
          AND QUT.QUALIFICATION_TYPE_ID = QUA.QUALIFICATION_TYPE_ID
          AND QUA.ATTENDANCE_ID = ESA.ATTENDANCE_ID(+)
          AND ESA.ESTABLISHMENT_ID = EST.ESTABLISHMENT_ID(+)
          AND QT.QUALIFICATION_ID = QUA.QUALIFICATION_ID
          and ppf.person_id=paf.person_id
          and pj.JOB_DEFINITION_ID=pjd.JOB_DEFINITION_ID
          and pj.JOB_ID=paf.JOB_ID
          and ppg.PEOPLE_GROUP_ID=paf.PEOPLE_GROUP_ID
          AND pou.organization_id(+) = paf.organization_id
          and ppf.person_id=ampv.person_id
          and past.ASSIGNMENT_STATUS_TYPE_ID=paf.ASSIGNMENT_STATUS_TYPE_ID
          AND paf.assignment_id = pcaf.ASSIGNMENT_ID(+)
          and CONFIRMATION.person_id(+)= ppf.person_id
          and ADDRESS.PERSON_ID(+)=ppf.PERSON_ID
          and esa.person_id(+)=paf.person_id
          and ppf.person_id=pptu.person_id(+)
          and paf.LOCATION_ID=hrl.LOCATION_ID
          and pou.ORGANIZATION_ID=paf.ORGANIZATION_ID
          and pptu.PERSON_TYPE_ID=ppt.PERSON_TYPE_ID
          and  papf.BUSINESS_GROUP_ID=paf.BUSINESS_GROUP_ID
          and papf.PAYROLL_ID=paf.PAYROLL_ID
          AND NVL (pcaf.COST_ALLOCATION_KEYFLEX_ID, 1) =
                  pcak.COST_ALLOCATION_KEYFLEX_ID(+)
          and ppf.person_id=DECODE (QUA.PERSON_ID, NULL, ESA.PERSON_ID, QUA.PERSON_ID)
--          and DECODE (QUA.PERSON_ID, NULL, ESA.PERSON_ID, QUA.PERSON_ID)=85772
         and ppf.employee_number=29688
         and ppt.USER_PERSON_TYPE<>'Ex-applicant'
         AND TRUNC (SYSDATE) BETWEEN PPF.EFFECTIVE_START_DATE
                                    AND  PPF.EFFECTIVE_END_DATE
         AND TRUNC (SYSDATE) BETWEEN PAF.EFFECTIVE_START_DATE
                                    AND  PAF.EFFECTIVE_END_DATE
        AND TRUNC (SYSDATE) BETWEEN PCAF.EFFECTIVE_START_DATE
                                    AND  PCAF.EFFECTIVE_END_DATE
       AND TRUNC (SYSDATE) BETWEEN PPTU.EFFECTIVE_START_DATE
                                    AND  PPTU.EFFECTIVE_END_DATE
       AND TRUNC (SYSDATE) BETWEEN PAPF.EFFECTIVE_START_DATE
                                    AND  PAPF.EFFECTIVE_END_DATE
       AND QT.LANGUAGE = USERENV ('LANG')
       order by (to_date (AWARDED_DATE,'DD-MON-YYYY'))


--------------------------------------------------------------------------------

select 
    CASE
               WHEN POU.NAME IN
                          ('Flat Steel Factory',
                           'Long Steel Factory',
                           'Steel Division',
                           'Steel Melting Factory')
               THEN
                  'Steel Division'
               WHEN POU.NAME IN ('Abul Khair Group')
               THEN
                  'GROUP COMMON'
               ELSE
                  'Cement Division'
            END
               "Division",
               pou.name ORGANIZATION,
               PPG.SEGMENT1 PEOPLE_GROUP,
               PJD.SEGMENT1 Department,
               PJD.SEGMENT2 SUB_DEPARTMENT,
               paaf.SUPERVISOR_id,
           APPS.XXAKG_ORACLE_PKG.GET_SUPERVISOR_NAME (paaf.person_id) SUPERVISOR_NAME,
           ppf.employee_number,ppf.full_name,hapf.name Designation,pjd.SEGMENT3 JOB_LEVEL,pj.NAME JOB_NAME,
           ppsf.PAYROLL_NAME,ppt.USER_PERSON_TYPE PERSON_TYPE,
           TO_NUMBER (NVL (LKP.DESCRIPTION, '0')) JOB_RANK,
           hrl.LOCATION_CODE Location_name
from APPS.PER_ALL_ASSIGNMENTS_F paaf,
        apps.per_organization_units pou,
        apps.per_all_people_f ppf,
        apps.PAY_PEOPLE_GROUPS PPG,
        apps.per_job_definitions pjd,
        apps.per_jobs pj,
        apps.hr_all_positions_f hapf,
        apps.pay_payrolls_f ppsf,
        apps.per_person_types ppt,
        apps.per_person_type_usages_f pptu,
       apps.FND_LOOKUP_VALUES_VL LKP,
       apps.hr_locations hrl
where paaf.ORGANIZATION_ID=pou.ORGANIZATION_ID
and ppf.person_id=paaf.person_id
and ppg.people_group_id(+)=paaf.people_group_id
and pjd.JOB_DEFINITION_ID=pj.JOB_DEFINITION_ID
AND NVL (PAAF.JOB_ID, 1) = PJ.JOB_ID(+)
AND NVL (PAAF.POSITION_ID, 1) = HAPF.POSITION_ID(+)
AND NVL (paaf.payroll_id, 1) = ppsf.payroll_id(+)
and ppf.person_id = pptu.person_id
AND pptu.person_type_id = ppt.person_type_id
AND LKP.MEANING = PJD.SEGMENT3
AND LKP.LOOKUP_TYPE = 'AKG_JOB_LEVELS'
AND NVL (paaf.location_id, 1) = hrl.location_id(+)
and ppt.USER_PERSON_TYPE<>'Ex-employee'
--and pou.name='Marble'
and ppt.USER_PERSON_TYPE='Confirmed'
and sysdate between paaf.effective_start_date and paaf.effective_end_date
and sysdate between ppf.effective_start_date and ppf.effective_end_date
and sysdate between hapf.effective_start_date and hapf.effective_end_date
and sysdate between ppsf.effective_start_date and ppsf.effective_end_date
and sysdate between pptu.effective_start_date and pptu.effective_end_date
and ppf.employee_number=32053
