select
--    moq.*
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
--    msi.description,
    moq.SUBINVENTORY_CODE,
    SUM(NVL(moq.TRANSACTION_QUANTITY,0)) ON_HAND_QTY
from 
    APPS.MTL_ONHAND_QUANTITIES moq,
    INV.MTL_SYSTEM_ITEMS_B msi
where
    moq.inventory_item_id=msi.inventory_item_id
    and moq.ORGANIZATION_ID=msi.organization_id
    and moq.subinventory_code in ('CER-RM STR')--'SCP - GEN'--
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in 
    ('DRCT.CLAY.0001',
'DRCT.CLAY.0007',
'DRCT.CLAY.0004',
'DRCT.CLAY.0005',
'DRCT.CLAY.0002',
'DRCT.CLAY.0006',
'DRCT.CLAY.0008',
'DRCT.CLAY.0009',
'DRCT.CLAY.0011',
'DRCT.SODI.0003',
'DRCT.PWDR.0001',
'DRCT.PWDR.0005',
'DRCT.PWDR.0003',
'DRCT.REMB.0001',
'DRCT.SODI.0001',
'DRCT.HEXA.0001',
'DRCT.SAND.0001',
'DRCT.PWDR.0004',
'DRCT.DMND.0001',
'SCRAP.CAST.0001')
--    and trunc(moq.DATE_RECEIVED) < '01-OCT-2013'
group by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
--    msi.description,
    moq.SUBINVENTORY_CODE
order by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3--,
--    moq.SUBINVENTORY_CODE    