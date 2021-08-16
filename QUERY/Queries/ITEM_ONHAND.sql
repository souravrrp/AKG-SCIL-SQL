select
--    moq.*
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description,
    MIC.SEGMENT1 Catg_Segment1,
    MIC.SEGMENT2 Catg_Segment2,
--    msi.description,
    moq.SUBINVENTORY_CODE,
    si.description SUB_INV_DESC,
    SUM(NVL(moq.TRANSACTION_QUANTITY,0)) ON_HAND_QTY
from 
    APPS.MTL_ONHAND_QUANTITIES moq,
    INV.MTL_SYSTEM_ITEMS_B msi,
    apps.mtl_item_categories_v mic,
    INV.MTL_SECONDARY_INVENTORIES si
where
    moq.inventory_item_id=msi.inventory_item_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and moq.ORGANIZATION_ID=msi.organization_id
    and MSI.ORGANIZATION_ID=si.organization_id
    and moq.subinventory_code=si.secondary_inventory_name
--    and moq.subinventory_code in 
--        ('CER-CEN ST')--('MRB-RM STR')--('ACP-GEN')--('SPRAY')--'SCP - GEN'--('AKC-GEN ST')--
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in 
    ('MCSU.WCLI.1801',
'GCSP.BMSK.1801',
'GCSP.STLG.1801',
'GCSP.STLG.1801',
'GCSP.BGLX.1801',
'GCSP.RMHG.1801',
'GCSP.STLG.1801',
'GCSP.STLG.1801',
'MCSP.OCNC.1801',
'MCSP.TCTA.1801',
'MCSP.ABBL.1201',
'MCSU.JGUR.1801',
'GCSP.TNBR.1801')
--    and MIC.SEGMENT1='INGREDIENT'
    and msi.organization_id=606
--    and msi.description in ('Marble  Block Mugla White')
--    and trunc(moq.DATE_RECEIVED) < '01-DEC-2013'
group by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    MIC.SEGMENT1,
    MIC.SEGMENT2,
    moq.SUBINVENTORY_CODE,
    si.description
order by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3--,
--    moq.SUBINVENTORY_CODE    