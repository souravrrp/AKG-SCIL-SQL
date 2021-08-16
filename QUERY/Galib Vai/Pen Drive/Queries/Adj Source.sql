SELECT MMT.*
FROM 
    APPS.MTL_SYSTEM_ITEMS_B MSI,
    APPS.MTL_MATERIAL_TRANSACTIONS MMT
WHERE MSI.ORGANIZATION_ID=MMT.ORGANIZATION_ID
AND MMT.TRANSACTION_SOURCE_NAME = 'Physical vs Oracle Adj'
AND MMT.ORGANIZATION_ID = '99'
AND MSI.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
--AND ROWNUM<=5



SELECT 
    MMT.TRANSACTION_SOURCE_NAME,
    MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
    MSI.DESCRIPTION,
    MMT.SUBINVENTORY_CODE,
    MSI.PRIMARY_UOM_CODE,
    TRUNC(MMT.TRANSACTION_DATE),
    SUM(NVL(MMT.PRIMARY_QUANTITY,0)) TXN_QTY--,
--    MMT.*
FROM 
    APPS.MTL_SYSTEM_ITEMS_B MSI,
    APPS.MTL_MATERIAL_TRANSACTIONS MMT
WHERE MSI.ORGANIZATION_ID=MMT.ORGANIZATION_ID
AND MMT.TRANSACTION_SOURCE_NAME = 'Physical vs Oracle Adj'
AND MMT.ORGANIZATION_ID = '99'
AND MSI.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
--AND ROWNUM<=5
GROUP BY   
    MMT.TRANSACTION_SOURCE_NAME,
    MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3,
    MSI.DESCRIPTION,
    MMT.SUBINVENTORY_CODE,
    MSI.PRIMARY_UOM_CODE,
    TRUNC(MMT.TRANSACTION_DATE)