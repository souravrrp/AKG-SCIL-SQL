select
--    *
    count(distinct batch_no)    
from
(select 
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')) PRODUCTION_DATE,
    gbh.ATTRIBUTE10 PROCESS,
    gbh.BATCH_NO,
    DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS, 
    trunc(gbh.PLAN_START_DATE) PLAN_START_DATE,      
    trunc(gbh.ACTUAL_START_DATE) ACTUAL_START_DATE,
    max(trunc(mmt.transaction_date)) TXN_DATE,
    trunc(gbh.ACTUAL_CMPLT_DATE) COMPLETION_DATE,
    trunc(gbh.BATCH_CLOSE_DATE) CLOSE_DATE
from 
    GME.GME_BATCH_HEADER gbh,
     INV.MTL_MATERIAL_TRANSACTIONS mmt
where 
    GBH.ORGANIZATION_ID=99
    and mmt.organization_id=gbh.organization_id
    and MMT.TRANSACTION_SOURCE_ID=GBH.BATCH_ID
    and mmt.transaction_source_type_id=5
group by
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    gbh.ATTRIBUTE10,
    gbh.BATCH_NO, 
    gbh.BATCH_STATUS,
    trunc(gbh.PLAN_START_DATE),
    trunc(gbh.ACTUAL_START_DATE),
    trunc(mmt.transaction_date),
    trunc(gbh.ACTUAL_CMPLT_DATE),
    trunc(gbh.BATCH_CLOSE_DATE)
--order by
--    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
--    gbh.ATTRIBUTE10,
--    gbh.BATCH_NO        
 )
where
    (PLAN_START_DATE between '1-OCT-2013' and '31-OCT-2013' or ACTUAL_START_DATE between '1-OCT-2013' and '31-OCT-2013')
--    and (COMPLETION_DATE > '31-OCT-2013' or CLOSE_DATE > '31-OCT-2013' or TXN_DATE>'31-OCT-2013')
--    and (TXN_DATE>'31-OCT-2013')
    or TXN_DATE between '01-OCT-2013' and '31-OCT-2013'
order by PRODUCTION_DATE 

/*---- Batch Close Accross The Period*/ 
