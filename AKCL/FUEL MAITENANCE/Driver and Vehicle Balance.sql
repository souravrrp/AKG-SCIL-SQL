SELECT
    MOVE_ORDER_NO,
    VEHICLE_NUMBER,
    DRIVER_ID,
    DRIVER_NAME,
    FUEL_BLANCE,
    PROVIDED_FUEL,
    ACCTUAL_CONSUMPTION,
    TRIP_REMAINING
--    SUM(TRIP_REMAINING) BALANCE
--    ,REMAINING_FUEL
FROM
    APPS.XXAKG_FUEL_MAINTANANCE FU
    WHERE 1=1
    AND FU.ORGANIZATION_ID=84   -- IN (84,85)
--    AND DRIVER_ID=1919
--    AND VEHICLE_NUMBER='D.M.U-11-3894'
--GROUP BY DRIVER_ID,DRIVER_NAME
--,VEHICLE_NUMBER
--,FUEL_BLANCE,    PROVIDED_FUEL,    ACCTUAL_CONSUMPTION,    REMAINING_FUEL
    
----------------------------********************------------------------------------

select
 VEHICLE_NUMBER,
 DRIVER_ID,
 DRIVER_NAME,
 case when DRIVER_ID=employee_number then
 opening_balance+nvl(trip_remaining,0) else
 trip_remaining end closing_balance
 from
(select  
 VEHICLE_NUMBER,
 DRIVER_ID,
 DRIVER_NAME,
 papf.employee_number,
 opening_balance,
 sum(TRIP_REMAINING) trip_remaining,
 nvl(opening_balance,0)+sum(TRIP_REMAINING) vehicle_balance
  from 
   xxakg_fuel_maintanance xfm  ,
   pqp_vehicle_repository_f pvrf,
   per_all_people_f papf
  where 
   papf.person_id(+)=pvrf.vre_attribute19 
   and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(papf.effective_start_date,SYSDATE)) AND TRUNC(NVL(papf.effective_end_date,(SYSDATE+1)))
   and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(pvrf.effective_start_date,SYSDATE)) AND TRUNC(NVL(pvrf.effective_end_date,(SYSDATE+1)))
  and pvrf.registration_number=xfm.VEHICLE_NUMBER
 group by
 VEHICLE_NUMBER,
 DRIVER_ID,
 papf.employee_number,
 DRIVER_NAME,
 opening_balance)
 where driver_id='12097'--:driver_balance.driver_id
 
 
----------------------------********************------------------------------------
SELECT
DRIVER_ID
,DRIVER_NAME
--,SUM(BALANCE) BALANCE
,BALANCE
,FBD.*
FROM
APPS.XXAKG_FUEL_BALANCE_DETAILS FBD
WHERE 1=1
--AND DRIVER_ID=1547
--GROUP BY DRIVER_ID,DRIVER_NAME

----------------------------********************------------------------------------

SELECT
*
FROM
APPS.XXAKG_FUEL_BALANCE FB
WHERE 1=1
--AND DRIVER_ID=1547
--AND CREATED_BY='5936'
--AND EXISTS(SELECT 1 FROM APPS.FND_USER FU WHERE FB.CREATED_BY=FU.USER_ID AND FU.USER_NAME='11443')  --TO_CHAR(FU.USER_NAME) LIKE TO_CHAR('%'||:EMP_ID||'%'))
ORDER BY FB.CREATION_DATE DESC
