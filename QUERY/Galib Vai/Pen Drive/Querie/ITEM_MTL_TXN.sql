select
--    mmt.*
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    TO_CHAR(mmt.transaction_date,'MON-YY') Period,
    mmt.TRANSACTION_ID,
    mtt.TRANSACTION_TYPE_NAME TXN_TYPE_NAME,
    mtt.DESCRIPTION TXN_TYPE_DESC,
    SUM(NVL(mmt.TRANSACTION_QUANTITY,0)) TXN_QTY
from 
    INV.MTL_MATERIAL_TRANSACTIONS mmt,
    INV.MTL_TRANSACTION_TYPES mtt,
    INV.MTL_SYSTEM_ITEMS_B msi
where
    msi.inventory_item_id=mmt.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('FLSR.FLSR.0013','COVR.PLST.0013','COVR.PLST.0012','INDI.NANA.0038','INDI.NANA.0039','INDI.NANA.0015')
    and trunc(mmt.TRANSACTION_DATE) between '01-AUG-13' and '31-AUG-13'
--    and rownum<10    
group by
    TO_CHAR(mmt.transaction_date,'MON-YY'),
    mmt.TRANSACTION_ID,
    mtt.TRANSACTION_TYPE_NAME,
    mtt.DESCRIPTION,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3
order by
    to_date(TO_CHAR(transaction_date,'MON-YY'),'MON-YY'),
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    TRANSACTION_ID
        