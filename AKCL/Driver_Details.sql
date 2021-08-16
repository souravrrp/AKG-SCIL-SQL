SELECT PAPF.EMPLOYEE_NUMBER||'-'||PAPF.FULL_NAME 
        FROM APPS.PQP_VEHICLE_REPOSITORY_F VM,
            APPS.PER_ALL_PEOPLE_F PAPF
         WHERE  VM.VEHICLE_STATUS = 'A'
          AND VM.VRE_ATTRIBUTE2 = 82
          AND TRUNC (SYSDATE) BETWEEN VM.EFFECTIVE_START_DATE          
          AND NVL (VM.EFFECTIVE_END_DATE, TRUNC (SYSDATE))
          AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
          AND PAPF.PERSON_ID=VM.VRE_ATTRIBUTE19
          AND VM.REGISTRATION_NUMBER='D.M.U-11-0193'--uses.use_of_area
--          AND PAPF.EMPLOYEE_NUMBER='5259'
          
          select DRIVER_EMP_NUM||' - '||DRIVER_NAME,DD.*   from  apps.XXAKG_DRIVER_DETAILS DD WHERE 1=1 AND REG_NUMBER='D.M.U-11-0193' --AND DRIVER_EMP_NUM=5259
          
          
------------------------------------------------------------------------------------------------
SELECT
*
FROM
APPS.XXAKG_DRIVER_V

------------------------------------------------------------------------------------------------
