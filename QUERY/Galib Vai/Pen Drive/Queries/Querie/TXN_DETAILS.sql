select
--    *
--    min(trunc(TRANSACTION_DATE)),max(trunc(TRANSACTION_DATE))
    ITEM_NUMBER,
--    EVENT_ID,
--    TRANSACTION_ID,
--    TRANSACTION_DATE,
    SUBINVENTORY_CODE,
--    ORGANIZATION_ID,
--    TRANSACTION_SOURCE_TYPE,
    JOURNAL_LINE_TYPE,
    SUM(NVL(TXN_BASE_VALUE,0)) TXN_VALUE
from GMF.GMF_TRANSACTION_VALUATION
where
    LEDGER_ID=2025
    and ORG_ID=85
--    and ITEM_NUMBER like '%%'
    and ITEM_NUMBER in ('DRCT.CLNK.0001','DRCT.FLSH.0001','DRCT.GYPS.0001','DRCT.LIME.0001','DRCT.LIME.0002')
    and trunc(TRANSACTION_DATE) < '01-OCT-2013'
group by
        ITEM_NUMBER,
--        EVENT_ID,
--        TRANSACTION_ID,
--    TRANSACTION_DATE,
    SUBINVENTORY_CODE,
--    ORGANIZATION_ID,
--    TRANSACTION_SOURCE_TYPE,
    JOURNAL_LINE_TYPE
order by
        ITEM_NUMBER,
--        EVENT_ID,
--        TRANSACTION_ID,
--    TRANSACTION_DATE,
    SUBINVENTORY_CODE,
--    ORGANIZATION_ID,
--    TRANSACTION_SOURCE_TYPE,
    JOURNAL_LINE_TYPE        
    
    
    
select 
    *
--    event_id,
--    count(*) 
from GMF.GMF_TRANSACTION_VALUATION 
where 
        LEDGER_ID=2025
    and ORG_ID=85
    and ITEM_NUMBER='DRCT.CLNK.0001'
    and trunc(TRANSACTION_DATE) between '01-AUG-2011' and '31-AUG-2011'


group by
    event_id    
order by
    event_id        