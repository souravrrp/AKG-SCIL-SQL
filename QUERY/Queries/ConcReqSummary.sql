select 
*
--    REQUEST_ID,
--    PROGRAM,
----    STATUS_CODE,
----    COMPLETION_TEXT
----    ARGUMENT_TEXT,
--    (ACTUAL_COMPLETION_DATE- ACTUAL_START_DATE)*24*60 TimeTaken
from 
    apps.FND_CONC_REQ_SUMMARY_V
--     apps.FND_CONCURRENT_REQUESTS
 where 
    PROGRAM='OPM Cost Allocation Process'
--    trunc(REQUESTED_START_DATE)=to_date('21-JUL-13','DD-MON-YY')
--    and ARGUMENT_TEXT='85, , , , , 2013/06/30 00:00:00, 2013/06/30 00:00:00'
--    and 
--    CONCURRENT_PROGRAM_ID=117331
--    REQUEST_ID in (9973457,9966534,9958417,9973555)
--    and 
--    rownum<10
--    STATUS_CODE='G'
--REQUESTOR


group by
    STATUS_CODE,
    COMPLETION_TEXT
--order by  (ACTUAL_COMPLETION_DATE- ACTUAL_START_DATE)*24*60 desc



select
    *
--    REQUEST_ID,
--    PROGRAM,
--    STATUS_CODE,
--    COMPLETION_TEXT,
----    ARGUMENT_TEXT,
--    (ACTUAL_COMPLETION_DATE- ACTUAL_START_DATE)*24*60 TimeTaken
----    (sysdate- ACTUAL_START_DATE)*24*60 TimeTaken
from apps.FND_CONC_REQ_SUMMARY_V
where
--    REQUEST_ID=10276802 
  REQUEST_ID=10347771--10292180   
  
  
  
select
    r.*
from
    apps.FND_CONCURRENT_PROGRAMS PB,
    apps.FND_CONCURRENT_REQUESTS R
where
        PB.APPLICATION_ID = R.PROGRAM_APPLICATION_ID
          AND PB.CONCURRENT_PROGRAM_ID = R.CONCURRENT_PROGRAM_ID  
--          and DECODE (
--             R.DESCRIPTION,
--             NULL,
--             PT.USER_CONCURRENT_PROGRAM_NAME,
--             R.DESCRIPTION || ' (' || PT.USER_CONCURRENT_PROGRAM_NAME || ')')=
--             and r.description like '%OPM%Cost%Allocation%Process%'
    and R.CONCURRENT_PROGRAM_ID=38486