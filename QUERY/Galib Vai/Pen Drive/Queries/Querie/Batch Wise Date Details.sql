select
    *
--    count(distinct batch_no)    
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
    trunc(gbh.Plan_START_DATE) Plan_START_DATE,     
    trunc(gbh.ACTUAL_START_DATE) START_DATE,
    max(trunc(mmt.transaction_date)) TXN_DATE,
    min(trunc(mmt.transaction_date)) mTXN_DATE,
    trunc(gbh.ACTUAL_CMPLT_DATE) COMPLETION_DATE,
    trunc(gbh.BATCH_CLOSE_DATE) CLOSE_DATE
from 
    GME.GME_BATCH_HEADER gbh,
     INV.MTL_MATERIAL_TRANSACTIONS mmt
where 
    GBH.ORGANIZATION_ID=99
    and MMT.TRANSACTION_SOURCE_ID=GBH.BATCH_ID and mmt.ORGANIZATION_ID=gbh.ORGANIZATION_ID
    and mmt.transaction_source_type_id=5 
--    and gbh.BATCH_STATUS not in (4,-1,1)
group by
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    gbh.ATTRIBUTE10,
    gbh.BATCH_NO, 
    gbh.BATCH_STATUS,
     trunc(gbh.Plan_START_DATE),
    trunc(gbh.ACTUAL_START_DATE),
--    max(trunc(mmt.transaction_date)),
    trunc(gbh.ACTUAL_CMPLT_DATE),
    trunc(gbh.BATCH_CLOSE_DATE)
--order by
--    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
--    gbh.ATTRIBUTE10,
--    gbh.BATCH_NO        
 )
where
    (Plan_START_DATE between '1-OCT-2013' and '31-OCT-2013' or START_DATE between '1-OCT-2013' and '31-OCT-2013' )
     and mtxn_date> '31-OCT-2013'
--    and( COMPLETION_DATE>= '1-NOV-2013'  or CLOSE_DATE >= '1-NOV-2013' or txn_date>= '1-NOV-2013')
--    and CLOSE_DATE > '31-OCT-2013'
--    and TXN_DATE > '31-OCT-2013'
order by PRODUCTION_DATE 

/*---- Batch Close Accross The Period*/ 

