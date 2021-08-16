select 
--    *
     DECODE(ORGANIZATION_ID,
     99,'CER',
     100,'RMC',
     101,'SCI',
     113,'PSU',
     201,'RMT',
     365,'SSG',
     444,'BCM') ORGANIZATION,
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
    BATCH_NO=48 and 
    ORGANIZATION_ID in (99,100,101,113,201,365,444) and 
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
    DECODE(ORGANIZATION_ID,
     99,'CER',
     100,'RMC',
     101,'SCI',
     113,'PSU',
     365,'SSG',
     444,'BCM') ORGANIZATION,
    batch_no,
    count(*) count 
from GME.GME_BATCH_HEADER
where
    ORGANIZATION_ID in (99,100,101,113,201,365,444) and 
    TRUNC(PLAN_START_DATE) between '01-OCT-2013' and '31-OCT-2013' and  
    TRUNC(BATCH_CLOSE_DATE) > '31-OCT-2013'
group by
    organization_id,
    batch_no
order by
    organization_id,
    batch_no;        
    