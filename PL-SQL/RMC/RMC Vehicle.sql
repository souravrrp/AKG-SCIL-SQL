------------------------**********RMC VEHICLE**********------------------------
SELECT
--VR.VEHICLE_REPOSITORY_ID,
VR.REGISTRATION_NUMBER,
NVL(VR.FISCAL_RATINGS,0) FISCAL_KPL,
NVL(VRE_ATTRIBUTE20,VR.FISCAL_RATINGS) DISTRICT_KPL,
PAPF.EMPLOYEE_NUMBER,
PAPF.FULL_NAME 
--,VR.*
FROM
APPS.PQP_VEHICLE_REPOSITORY_F VR
,APPS.PER_ALL_PEOPLE_F PAPF
WHERE 1=1
AND PAPF.PERSON_ID(+)=VR.VRE_ATTRIBUTE19 
AND VR.VRE_ATTRIBUTE2=84
--AND VRE_ATTRIBUTE3='RMC'
--AND REGISTRATION_NUMBER LIKE '%0192%'--D.M.U-11-1118'--'
--AND VR.VEHICLE_STATUS='A'--'I'
--AND VRE_ATTRIBUTE3='Road Transport'
AND  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(PAPF.EFFECTIVE_START_DATE,SYSDATE)) AND TRUNC(NVL(PAPF.EFFECTIVE_END_DATE,(SYSDATE+1)))
--AND SYSDATE BETWEEN EFFECTIVE_START_DATE AND EFFECTIVE_END_DATE
AND  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(VR.EFFECTIVE_START_DATE,SYSDATE)) AND TRUNC(NVL(VR.EFFECTIVE_END_DATE,(SYSDATE+1)));


------------------------**********RMC DISTANCE**********------------------------
SELECT 
TO_LOCATION,
TRANSPORT_MODE,
NVL(DISTANCE,0) DISTANCE
FROM
APPS.XXAKG_TRANSPORT_HIRERATE
      WHERE ORG_ID IN (84)
      AND FROM_LOCATION IN (100,201)
      AND TRANSPORT_MODE IN ('Company Truck')
--      AND TO_LOCATION LIKE '%Madaripur%'
      AND END_DATE_ACTIVE  IS NULL;     
      
      
---------------------------------------Risk and VTS Percentage----------------------------     

SELECT
    DISTINCT INITCAP(QR.CHARACTER1) FINAL_DESTINATION,
    QR.CHARACTER2 DESTINATION_TYPE,
    NVL(TO_NUMBER(QR.CHARACTER3),0) RISK_PERCENTAGE,
    NVL(TO_NUMBER(QR.CHARACTER4),0) VTS_PERCENTAGE 
FROM
    QA.QA_PLANS QP,
    QA.QA_RESULTS QR
WHERE
    QP.NAME='FINAL DESTINATION RISK PERCENT'
    AND QP.PLAN_ID=QR.PLAN_ID
--    AND QR.CHARACTER1 LIKE '%Madaripur%'