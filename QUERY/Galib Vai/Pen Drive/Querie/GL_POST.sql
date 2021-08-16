select *
from apps.xxakg_gl_details_statement_mv
where rownum<10


select 
--    *
--   JE_CATEGORY,
     BATCH_NAME,
         JE_SOURCE, 
  JE_HEADER_ID,  
    DOC_SEQUENCE_VALUE,
    BATCH_RUNNING_TOTAL_DR,
  BATCH_RUNNING_TOTAL_CR 
FROM APPS.GL_JE_BATCHES_HEADERS_V 
WHERE
    LEDGER_ID=2025
    and PERIOD_NAME='JUN-13'
    and BATCH_NAME like 'CEMENT_30_JUN_2013_INV_BATCH%'
--    and JE_CATEGORY='Inventory'
--    and ROWNUM<10