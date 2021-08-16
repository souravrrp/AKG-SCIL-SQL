/*
BATCH STATUS CODE
-1==CANCELED
1==PENDING
2==WIP
3==COMPLETED
4==CLOSED
*/
select 
--    *
     ORGANIZATION_ID,
     BATCH_NO,
     DECODE(BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,  
     count(*) COUNT
from GME.GME_BATCH_HEADER 
where 
--    BATCH_NO=22956 and 
    ORGANIZATION_ID in (89,91,92,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,201,281,362,365,424,425,444,484,524,564) and 
    TRUNC(PLAN_START_DATE) between '01-OCT-2013' and '31-OCT-2013' --and  
--    BATCH_CLOSE_DATE is NULL and 
--    BATCH_STATUS<>-1
group by
    BATCH_NO, 
    ORGANIZATION_ID,
    BATCH_STATUS
order by
    BATCH_NO, 
    ORGANIZATION_ID,
    BATCH_STATUS;          



-----------------------------------------
--*************************--
-----------------------------------------
select
--    *
    organization_id,
    batch_no,
    count(*) count 
from GME.GME_BATCH_HEADER
where
    ORGANIZATION_ID in (89,91,92,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,201,281,362,365,424,425,444,484,524,564) and 
    TRUNC(PLAN_START_DATE) between '01-AUG-2013' and '31-AUG-2013' and  
    TRUNC(BATCH_CLOSE_DATE) > '31-AUG-2013'
group by
    organization_id,
    batch_no
order by
    organization_id,
    batch_no;        
    