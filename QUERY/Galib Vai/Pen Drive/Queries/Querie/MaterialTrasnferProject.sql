---- Misc. Issue: Transaction_Type_id=32

select 
--    mmt.*
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    TRANSACTION_ID,
    TRANSACTION_QUANTITY 
from 
    INV.MTL_MATERIAL_TRANSACTIONS mmt,
    INV.MTL_SYSTEM_ITEMS_B msi 
where 
    mmt.inventory_item_id=msi.inventory_item_id
    and trunc(TRANSACTION_DATE)='11-SEP-2013'
--    and MMT.TRANSACTION_TYPE_ID=32 ---Misc. Issue
    and MMT.TRANSACTION_TYPE_ID=42 ---Misc. Receive
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in 
--    ('PUMP.PUMP.0018','BALL.BRNG.2256')
    ('GEAR.PUMP.0002','BALL.BRNG.2250')
group by
    msi.segment1,msi.segment2,msi.segment3,
    TRANSACTION_ID,
    TRANSACTION_QUANTITY    