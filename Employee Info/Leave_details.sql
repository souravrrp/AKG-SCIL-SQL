SELECT aed.organization,
            aed.department,  
            aed.person_id,
            aed.employee_number,
            aed.full_name,
            aed.job_level,
            wf.notification_id,
            wf.BEGIN_DATE,
            wf.END_DATE,
            SUBSTR (wf.SUBJECT, 40) Pending_To,
            TO_CHAR (hat.transaction_effective_date, 'DD-MON-YY')
               Leave_Submission_Date,
            NVL (
               TO_CHAR (TO_DATE (hats.information1, 'RRRR-MM-DD'),
                        'DD-MON-YYYY'),
               TO_CHAR (TO_DATE (hats.information3, 'RRRR-MM-DD'),
                        'DD-MON-YYYY'))
               Leave_Start_Date,
            NVL (
               TO_CHAR (TO_DATE (hats.information2, 'RRRR-MM-DD'),
                        'DD-MON-YYYY'),
               TO_CHAR (TO_DATE (hats.information4, 'RRRR-MM-DD'),
                        'DD-MON-YYYY'))
               Leave_End_Date,
            hats.information8 Num_Days,
            abt.name Absence_type,
            paaf.EMPLOYMENT_CATEGORY,
            extractvalue(VALUE(xx_row), '/PerAbsenceAttendancesEORow/Comments') AS Comments
       FROM apps.hr_api_transactions hat,
                apps.per_all_assignments_f paaf,
            apps.hr_api_transaction_steps hats,
            apps.wf_notifications wf,
            APPS.akg_employee_details aed,
            apps.per_absence_attendance_types abt,
               TABLE(xmlsequence(extract(xmlparse(document transaction_document wellformed),
                                 '/Transaction/TransCache/AM/TXN/EO/PerAbsenceAttendancesEORow'))) xx_row,
            (  SELECT MAX (wf.notification_id) Notification_id
                 FROM apps.hr_api_transactions hat,
                      apps.hr_api_transaction_steps hats,
                      apps.wf_notifications wf,
                      APPS.akg_employee_details aed,
                      apps.per_absence_attendance_types abt
                WHERE     hat.transaction_ref_table = 'PER_ABSENCE_ATTENDANCES'
                      AND hat.transaction_group = 'ABSENCE_MGMT'
                      AND hat.transaction_identifier = 'ABSENCES'
                      AND hat.transaction_ref_id IS NOT NULL
                      AND hat.status = 'Y'
                      AND hat.transaction_id = hats.transaction_id
                      AND hat.ITEM_KEY = wf.ITEM_KEY
                      AND hat.ITEM_TYPE = 'HRSSA'
                      AND hat.creator_person_id = aed.person_id
                      AND aed.employee_number = wf.recipient_role --hAT.CREATOR_PERSON_ID
                      AND hats.information5 = abt.absence_attendance_type_id
--             and aed.employee_number =1948
--             and hat.transaction_effective_date between '26-APR-2016' and '25-MAY-2016'
--              and  to_date(to_char(to_date(hats.information1,'RRRR-MM-DD'),'DD-MON-YYYY')) between '20-MAR-2017' and '30-MAR-2017'
             GROUP BY hat.creator_person_id, hats.information1) a
      WHERE     hat.transaction_ref_table = 'PER_ABSENCE_ATTENDANCES'
            AND hat.transaction_group = 'ABSENCE_MGMT'
            AND hat.transaction_identifier = 'ABSENCES'
            AND hat.transaction_ref_id IS NOT NULL
            AND hat.status = 'Y'
            AND hat.transaction_id = hats.transaction_id
            AND hat.ITEM_KEY = wf.ITEM_KEY
            AND hat.ITEM_TYPE = 'HRSSA'
            AND hat.creator_person_id = aed.person_id
            and paaf.person_id=aed.person_id
            AND aed.employee_number = wf.recipient_role --hAT.CREATOR_PERSON_ID
            AND hats.information5 = abt.absence_attendance_type_id
            AND a.notification_id = wf.notification_id
            and sysdate between EFFECTIVE_START_DATE and EFFECTIVE_END_DATE
--            and aed.organization='RMC'
--            and paaf.EMPLOYMENT_CATEGORY<>'BN'
            and aed.location_name='Gulshan Office, Dhaka'
   --and aed.organization=:P_org
   and hat.transaction_effective_date between '23-APR-2017' and '31-MAY-2017'
   -- and  to_date(to_char(to_date(hats.information1,'RRRR-MM-DD'))) between :p_start_date and :p_end_date
--  and SUBSTR (wf.SUBJECT, 40)  like'%Molla%'
   ORDER BY 1,2,3;
   
   
   
select 
b.EMPLOYEE_NUMBER,b.FULL_NAME,b.JOB_LEVEL,b.DEPARTMENT,b.ORGANIZATION
,a.C_TYPE_DESC LEAVE_TYPE,to_char(to_date(a.DATE_START,'DD-MON-YYYY'))DATE_START,
to_char(to_date(a.DATE_END,'DD-MON-YYYY'))DATE_END,a.ABSENCE_DAYS
--distinct b.organization
    from 
    apps.XXAKG_LEAVE_BALANCE a,
    apps.AKG_EMPLOYEE_DETAILS b
   where a.person_id=b.person_id
--  and b.organization='CGD Factory'
--and b.PAYROLL_NAME='Cement - Corporate'
and b.LOCATION_NAME in ('Gulshan Office, Dhaka')
--and b.EMPLOYEE_NUMBER=7950
and A.DATE_START>='23-APR-2017'  and a.DATE_END<='31-MAY-2017'
